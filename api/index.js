const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
require('dotenv').config(); // Load environment variables

// 1. Import Turso Client
const { createClient } = require("@libsql/client");

const app = express();
app.use(cors());
app.use(express.json({ limit: '10mb' }));

// 2. Connect to Turso (The Cloud DB)
// Make sure you add these variables in Vercel Settings!
const client = createClient({
  url: process.env.TURSO_DATABASE_URL,
  authToken: process.env.TURSO_AUTH_TOKEN
});

// 3. The "Smart Wrapper"
// This makes Turso behave exactly like your old 'sqlite' library.
// 3. The "Smart Wrapper" (IMPROVED)
// Converts undefined -> null to prevent Turso crashes
// 3. The "Smart Wrapper" (Fixed for BigInt Crash)
const db = {
  get: async (sql, args = []) => {
    const safeArgs = args.map(arg => (arg === undefined ? null : arg));
    const rs = await client.execute({ sql, args: safeArgs });
    return rs.rows[0];
  },
  all: async (sql, args = []) => {
    const safeArgs = args.map(arg => (arg === undefined ? null : arg));
    const rs = await client.execute({ sql, args: safeArgs });
    return rs.rows;
  },
  run: async (sql, args = []) => {
    const safeArgs = args.map(arg => (arg === undefined ? null : arg));
    const rs = await client.execute({ sql, args: safeArgs });
    return {
      // 🚨 FIX: Convert BigInt to Number
      lastID: Number(rs.lastInsertRowid), 
      changes: rs.rowsAffected
    };
  }
};

// --- YOUR ORIGINAL APP LOGIC STARTS HERE ---

// API 1: ORG SIGN UP
app.post('/api/auth/register', async (request, response) => {
  try {
    const { orgName, adminName, email, password } = request.body

    if (password.length < 6) {
      response.status(400).send({ error: 'Password is too short' })
      return
    }

    const existingOrg = await db.get(`SELECT * FROM organisations WHERE name = ?`, [orgName])
    if (existingOrg) {
      response.status(400).send({ error: 'Organisation already exists' })
      return
    }

    const existingEmail = await db.get(`SELECT * FROM users WHERE email = ?`, [email])
    if (existingEmail) {
      response.status(400).send({ error: 'Email already registered' })
      return
    }

    const hashedPassword = await bcrypt.hash(password, 10)

    const insertOrgQuery = `INSERT INTO organisations (name) VALUES (?)`
    const orgResult = await db.run(insertOrgQuery, [orgName])
    const orgId = orgResult.lastID

    const userResult = await db.run(
      `INSERT INTO users (organisation_id, email, password_hash, name) VALUES (?, ?, ?, ?)`,
      [orgId, email, hashedPassword, adminName]
    )
    const userId = userResult.lastID

    await db.run(
      `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`,
      [orgId, userId, `Organisation ${orgId} Registered`]
    )

    const token = jwt.sign({ userId, orgId }, "SECRET_KEY", { expiresIn: "1h" })

    response.send({ token, userId, orgId })

  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Org not registered' })
  }
})

// API 2: ORG LOGIN
app.post('/api/auth/login', async (request, response) => {
  try {
    const { email, password } = request.body
    const user = await db.get(`SELECT * FROM users WHERE email = ?`, [email])

    if (!user) {
      response.status(400).send({ error: 'Invalid email' })
      return
    }

    const isPasswordValid = await bcrypt.compare(password, user.password_hash)
    if (!isPasswordValid) {
      response.status(400).send({ error: "Email and password didn't match" })
      return
    }

    const token = jwt.sign({ userId: user.id, orgId: user.organisation_id }, "SECRET_KEY", { expiresIn: "6h" })

    await db.run(
      `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`,
      [user.organisation_id, user.id, `User ${user.id} Logged In`]
    )

    response.send({ token, userId: user.id, orgId: user.organisation_id })
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Login failed' })
  }
})

// Middleware to authenticate token
const authMiddleware = (request, response, next) => {
  try {
    const authHeader = request.headers.authorization
    if (!authHeader) {
      return response.status(401).send({ error: 'No token' })
    }

    const token = authHeader.split(' ')[1]
    const payload = jwt.verify(token, "SECRET_KEY")

    request.user = { userId: payload.userId, orgId: payload.orgId }
    next()
  } catch (e) {
    console.log(e)
    response.status(401).send({ error: 'Invalid token' })
  }
}

// --- Employee CRUD APIs ---

// All Employees
app.get("/api/employees", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user;

    const search = request.query.search || "";
    const sort = request.query.sort || "name_asc";
    const gender = request.query.gender || "";

    let orderBy = "";
    let genderCondition = "";

    switch (sort) {
      case "name_asc":
        orderBy = "e.first_name ASC";
        break;

      case "name_desc":
        orderBy = "e.first_name DESC";
        break;

      case "date_new":
        orderBy = "e.created_at DESC";
        break;

      case "date_old": 
        orderBy = "e.created_at ASC";
        break;

      default:
        orderBy = "e.first_name ASC";
    }

    switch(gender){
        case "male":
            genderCondition = "AND e.gender = 'male'";
            break
        case "female":
            genderCondition = "AND e.gender = 'female'";
            break
        default:
            genderCondition = ""
    }

    const query = `
      SELECT 
        e.id,
        e.first_name,
        e.last_name,
        e.email,
        e.phone,
        e.gender,
        e.img_url,
        e.role,
        e.created_at,
        COALESCE(json_group_array(DISTINCT t.name), '[]') AS teams
      FROM employees e
      LEFT JOIN employee_teams et ON e.id = et.employee_id
      LEFT JOIN teams t ON et.team_id = t.id
      WHERE e.organisation_id = ? ${genderCondition}
      AND (
        LOWER(e.first_name) LIKE LOWER(?)
  OR LOWER(e.last_name) LIKE LOWER(?)
  OR LOWER(e.email) LIKE LOWER(?)
      )
      GROUP BY e.id
      ORDER BY ${orderBy};
    `;

    const employees = await db.all(query, [
      orgId,
      `%${search}%`,
      `%${search}%`,
      `%${search}%`,
    ]);

    const formattedEmployees = employees.map(emp => ({
        ...emp,
        teams: JSON.parse(emp.teams) 
    }));

    response.send(formattedEmployees);

  } catch (e) {
    console.log(e);
    response.status(500).send({ error: "Unable to fetch employees" });
  }
});



// 1 Employee
app.get("/api/employees/:id", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user
    const { id } = request.params
    const query = `
     SELECT 
        e.*, e.role,
        GROUP_CONCAT(t.name) AS teams
      FROM employees e
      LEFT JOIN employee_teams et ON e.id = et.employee_id
      LEFT JOIN teams t ON t.id = et.team_id
      WHERE e.id = ? AND e.organisation_id = ?
      GROUP BY e.id
    `
    const employee = await db.get(query, [id, orgId])
    
    if (!employee) {
        return response.status(404).send({error: 'Employee not found'})
    }
    response.send(employee)
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to fetch employee' })
  }
})

// Add Employee
app.post("/api/employees", authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user
    const { firstName, lastName, email, phone, gender, imgUrl, role } = request.body

    const query = `INSERT INTO employees (organisation_id, first_name, last_name, email, phone, gender, img_url, role) VALUES (?, ?, ?, ?, ?, ?, ?,?)`
    const result = await db.run(query, [orgId, firstName, lastName, email, phone, gender, imgUrl, role])
    const employeeId = result.lastID

    const logQuery = `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`
    await db.run(logQuery, [orgId, userId, `Added Employee ${employeeId} by User ${userId}`])
    
    response.status(201).send({ employeeId })
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to add employee' })
  }
})

// Update Employee
app.put("/api/employees/:id", authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user;
    const { id } = request.params;
    const { firstName, lastName, email, phone, gender, imgUrl, role } = request.body;

    const updateFields = [];
    const values = [];

    if (firstName !== undefined) {
      updateFields.push("first_name = ?");
      values.push(firstName);
    }
    if (lastName !== undefined) {
      updateFields.push("last_name = ?");
      values.push(lastName);
    }
    if (email !== undefined) {
      updateFields.push("email = ?");
      values.push(email);
    }
    if (phone !== undefined) {
      updateFields.push("phone = ?");
      values.push(phone);
    }
    if (gender !== undefined) {
      updateFields.push("gender = ?");
      values.push(gender);
    }
    if (imgUrl !== undefined) {
      updateFields.push("img_url = ?");
      values.push(imgUrl);
    }
    if (role !== undefined) {
      updateFields.push("role = ?");
      values.push(role);
    }

    if (updateFields.length === 0) {
      return response.status(400).send({ error: "No fields to update" });
    }

    const query = `
      UPDATE employees 
      SET ${updateFields.join(", ")} 
      WHERE id = ? AND organisation_id = ?
    `;
    
    values.push(id, orgId);

    const result = await db.run(query, values);

    if (result.changes === 0) {
      return response.status(404).send({ error: "Employee not found" });
    }

    await db.run(
      `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`,
      [orgId, userId, `Updated Employee ${id} by User ${userId}`]
    );

    response.send({ message: "Employee Updated Successfully" });

  } catch (e) {
    console.log(e);
    response.status(500).send({ error: "Unable to update employee" });
  }
});


// Delete Employee
app.delete("/api/employees/:id", authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user
    const { id } = request.params
    
    const query = `DELETE FROM employees WHERE id = ? AND organisation_id = ?`
    const result = await db.run(query, [id, orgId])

    if (result.changes === 0) {
      response.status(404).send({ error: 'Employee not found' })
      return
    }

    const logQuery = `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`
    await db.run(logQuery, [orgId, userId, `Deleted Employee ${id} by User ${userId}`])
    
    response.send({ message: 'Employee deleted successfully' })
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to delete employee' })
  }
})


// --- Teams CRUD APIs ---

// All Teams
app.get("/api/teams", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user
    const query = `
    SELECT 
        t.id,
        t.name,
        t.img_url,
        t.description,
        COUNT(et.employee_id) AS employee_count
      FROM teams t
      LEFT JOIN employee_teams et ON t.id = et.team_id
      WHERE t.organisation_id = ?
      GROUP BY t.id
    `
    const teams = await db.all(query, [orgId])
    response.send(teams)
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to fetch teams' })
  }
})

// 1 Team + Employees
app.get("/api/teams/:id", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user;
    const { id } = request.params;

    const teamQuery = `
      SELECT id, name, description, img_url
      FROM teams
      WHERE id = ? AND organisation_id = ?
    `;
    const team = await db.get(teamQuery, [id, orgId]);

    if (!team) {
      return response.status(404).send({ error: "Team not found" });
    }

    const employeeQuery = `
      SELECT 
        e.id,
        e.first_name,
        e.last_name,
        e.email,
        e.phone,
        e.gender,
        e.img_url,
        e.role,
        e.created_at
      FROM employees e
      JOIN employee_teams et ON e.id = et.employee_id
      WHERE et.team_id = ? AND e.organisation_id = ?
    `;
    const employees = await db.all(employeeQuery, [id, orgId]);

    response.send({
      ...team,
      employees: employees || []
    });

  } catch (e) {
    console.log(e);
    response.status(500).send({ error: "Unable to fetch team" });
  }
});

// Create New Team
app.post("/api/teams", authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user;
    const { name, description, imgUrl } = request.body;

    if (!name || name.trim() === "") {
      return response.status(400).send({ error: "Team name is required" });
    }

    const query = `
      INSERT INTO teams (organisation_id, name, description, img_url)
      VALUES (?, ?, ?, ?)
    `;
    const result = await db.run(query, [orgId, name, description || "", imgUrl || ""]);

    const teamId = result.lastID;


    const logQuery = `
      INSERT INTO logs (organisation_id, user_id, action)
      VALUES (?, ?, ?)
    `;
    await db.run(logQuery, [
      orgId,
      userId,
      `Team ${teamId} created by User ${userId}`
    ]);

    response.status(201).send({
      message: "Team created successfully",
      teamId,
    });

  } catch (e) {
    console.log(e);
    response.status(500).send({ error: "Unable to add team" });
  }
});

// Update Team
app.put("/api/teams/:id", authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user;
    const { id } = request.params;
    const { name, description, imgUrl } = request.body;

    
    let updateFields = [];
    let values = [];

    if (name !== undefined) {
      updateFields.push("name = ?");
      values.push(name);
    }

    if (description !== undefined) {
      updateFields.push("description = ?");
      values.push(description);
    }

    if (imgUrl !== undefined) {
      updateFields.push("img_url = ?");
      values.push(imgUrl);
    }

    
    if (updateFields.length === 0) {
      return response.status(400).send({
        error: "No fields provided to update",
      });
    }

    
    const query = `
      UPDATE teams 
      SET ${updateFields.join(", ")}
      WHERE id = ? AND organisation_id = ?
    `;

    values.push(id, orgId);

    const result = await db.run(query, values);

    if (result.changes === 0) {
      return response.status(404).send({ error: "Team not found" });
    }

   
    const logQuery = `
      INSERT INTO logs (organisation_id, user_id, action)
      VALUES (?, ?, ?)
    `;

    await db.run(logQuery, [
      orgId,
      userId,
      `Team ${id} updated by User ${userId}`,
    ]);

    response.send({ message: "Team updated successfully" });
  } catch (e) {
    console.log(e);
    response.status(500).send({ error: "Unable to update team" });
  }
});

// Delete Team
app.delete("/api/teams/:id", authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user
    const { id } = request.params
    
    const query = `DELETE FROM teams WHERE id = ? AND organisation_id = ?`
    const result = await db.run(query, [id, orgId])
    
    if (result.changes === 0) {
      response.status(404).send({ error: 'Team not found' })
      return
    }

    const logQuery = `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`
    await db.run(logQuery, [orgId, userId, `Team ${id} Deleted by User ${userId}`])
    
    response.send({ message: 'Team deleted successfully' })
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to delete team' })
  }
})

// Assign employee or employees to teams
app.post("/api/teams/:teamId/assign", authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user;
    const teamId = request.params.teamId;

    const { employeeId, employeeIds } = request.body;

    const ids = employeeIds || (employeeId ? [employeeId] : []);

    if (ids.length === 0) {
      return response.status(400).send({ error: "No employee IDs provided" });
    }

    const assigned = [];
    const skipped = [];
    const invalid = [];

    for (const id of ids) {

      
      const emp = await db.get(
        `SELECT id FROM employees WHERE id = ? AND organisation_id = ?`,
        [id, orgId]
      );

      if (!emp) {
        invalid.push(id);
        continue; 
      }

    
      const exists = await db.get(
        `SELECT 1 FROM employee_teams WHERE employee_id = ? AND team_id = ?`,
        [id, teamId]
      );

      if (exists) {
        skipped.push(id);
        continue;
      }

      
      await db.run(
        `INSERT INTO employee_teams (employee_id, team_id) VALUES (?, ?)`,
        [id, teamId]
      );

      assigned.push(id);
    }

    
    await db.run(
      `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`,
      [
        orgId,
        userId,
        `Assigned employees ${assigned.join(", ")} to team ${teamId} by user ${userId}`
      ]
    );

    response.send({
      teamId,
      assigned,
      skipped,
      invalid,
      message: "Employee assignment completed"
    });

  } catch (e) {
    console.log(e);
    response.status(500).send({ error: "Unable to assign employees to team" });
  }
});



// All employees in team
app.get("/api/teams/:id/employees", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user
    const { id } = request.params
    const query = `
            SELECT e.* FROM employees e
            JOIN employee_teams et ON e.id = et.employee_id
            WHERE et.team_id = ? AND e.organisation_id = ?`
    const employees = await db.all(query, [id, orgId])
    response.send(employees)
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to fetch employees in team' })
  }
})


// Employees not in a particular team
app.get("/api/teams/:teamId/available-employees", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user
    const { teamId } = request.params

   
    console.log(`Fetching available employees for Team: ${teamId}, Org: ${orgId}`);

    const query = `
      SELECT e.* FROM employees e
      LEFT JOIN employee_teams et 
        ON e.id = et.employee_id 
        AND et.team_id = ?
      WHERE e.organisation_id = ? 
      AND et.employee_id IS NULL
    `

    const employees = await db.all(query, [teamId, orgId])
    
    response.send(employees)
  } catch (e) {
    console.log("Error fetching available employees:", e)
    response.status(500).send({ error: "Unable to fetch available employees for this team" })
  }
})

//Employees with no team

app.get("/api/employees-without-team", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user

    const query = `
      SELECT * FROM employees 
      WHERE organisation_id = ? 
      AND id NOT IN (
        SELECT DISTINCT employee_id FROM employee_teams
      )
    `

    const employees = await db.all(query, [orgId])
    response.send(employees)
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: "Unable to fetch employees without a team" })
  }
})

// Remove employee from team
app.delete('/api/teams/:teamId/unassign', authMiddleware, async (request, response) => {
  try {
    const { orgId, userId } = request.user
    const { employeeId, employeeIds } = request.body
    const teamId = request.params.teamId

    const ids = employeeIds || (employeeId ? [employeeId] : [])

    if (ids.length === 0) {
      return response.status(400).json({ error: "No employee IDs provided" })
    }

    const unassigned = []
    const notFound = []
    const notInTeam = []

    for (const id of ids) {

    
      const employee = await db.get(`SELECT * FROM employees WHERE id = ?`, [id])
      if (!employee) {
        notFound.push(id)
        continue
      }

   
      const existsInTeam = await db.get(
        `SELECT * FROM employee_teams WHERE employee_id = ? AND team_id = ?`,
        [id, teamId]
      )

      if (!existsInTeam) {
        notInTeam.push(id)
        continue
      }


      await db.run(
        `DELETE FROM employee_teams WHERE employee_id = ? AND team_id = ?`,
        [id, teamId]
      )

      unassigned.push(id)
    }


    if (unassigned.length > 0) {
      await db.run(
        `INSERT INTO logs (organisation_id, user_id, action) VALUES (?, ?, ?)`,
        [
          orgId,
          userId,
          `Unassigned employees [${unassigned.join(", ")}] from team ID ${teamId} by User ${userId}`
        ]
      )
    }

    return response.json({
      message: "Unassign process completed",
      unassigned,
      notFound,
      notInTeam
    })
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to unassign employee from team' })
  }
})


// Logs API
app.get("/api/logs", authMiddleware, async (request, response) => {
  try {
    const { orgId } = request.user
    const query = `SELECT * FROM logs WHERE organisation_id = ? ORDER BY timestamp DESC`
    const logs = await db.all(query, [orgId])
    response.send(logs)
  } catch (e) {
    console.log(e)
    response.status(500).send({ error: 'Unable to fetch logs' })
  }
})

// 4. EXPORT APP FOR VERCEL
module.exports = app;

// 5. KEEP LOCAL LISTENER FOR TESTING
if (require.main === module) {
  app.listen(5000, () => {
    console.log('Server is Running at http://localhost:5000/')
  })
}
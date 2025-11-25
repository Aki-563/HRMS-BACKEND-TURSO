const { createClient } = require("@libsql/client");
const fs = require("fs");

// 1. PASTE YOUR CREDENTIALS HERE
const url = "libsql://hrmsdb-akilesh-563.aws-ap-south-1.turso.io"; 
const authToken = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCJ9.eyJhIjoicnciLCJpYXQiOjE3NjQwNjg0MzYsImlkIjoiZTk3NTc3YjYtNjI3MC00YzRlLWIwMmEtOTM4Y2E0YzNkZmY5IiwicmlkIjoiOTcwNGJkMmItYWEzYS00NTAyLWE5OTMtYmNhY2RkNjE2YWM1In0.SOYe5GSaZcCWYyIUwFeBK8Jk7JbTw2ctOVN6CPlJKVAE_YvlS7_Rr9tDkLP6p-2ijtWymkVEyISg9qKPEvsKAw";

const client = createClient({
  url: url,
  authToken: authToken,
});

async function uploadData() {
  try {
    console.log("📂 Reading dump.sql...");
    const rawSql = fs.readFileSync("dump.sql", "utf8");

    // 🛠️ THE FIX: Disable Foreign Key checks before running the SQL
    // This lets us insert data in any order without errors.
    const finalSql = `
      PRAGMA foreign_keys = OFF;
      
      ${rawSql}
      
      PRAGMA foreign_keys = ON;
    `;

    console.log("🚀 Uploading to Turso... (Ignoring Foreign Key rules temporarily)");
    
    await client.executeMultiple(finalSql);

    console.log("✅ Success! Your database is live.");
  } catch (err) {
    console.error("❌ Error uploading:", err);
  }
}

uploadData();
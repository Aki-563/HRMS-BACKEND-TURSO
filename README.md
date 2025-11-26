# HRMS Backend API

This is the backend of the **Human Resource Management System (HRMS)**.
It is built using **Node.js + Express** and deployed on **Vercel Serverless Functions**, connected to a **Turso (LibSQL)** database.

## 🚀 Live API Status
The backend is deployed and active:
* ✔ **Status:** Online
* ✔ **Scaling:** Auto-scaled by Vercel
* ✔ **Performance:** Instant responses (Zero cold-start optimization)

**Base URL:** `https://hrms-backend-turso.vercel.app/api/`

---

## 🛠️ Tech Stack
* **Runtime:** Node.js / Express
* **Infrastructure:** Vercel Serverless Functions
* **Database:** Turso (LibSQL / SQLite)
* **Authentication:** JWT (JSON Web Tokens)
* **Security:** Bcrypt (Password Hashing) & CORS

## 🗄️ Database Architecture (Turso)
The entire SQLite database (`hrms.db`) is hosted on **Turso’s Edge Network**.

**Key Benefits:**
* **Always Available:** High availability on the edge.
* **Zero Data Loss:** Persistent storage.
* **Unified Access:** Both local development (PC) and Vercel production connect to the same live DB.
* **Speed:** Extremely fast query execution.

---

## 🔌 How It Works (Serverless)
Unlike a traditional server that runs 24/7, this API uses a **Serverless Architecture**:


1.  **Function-based:** Every API route acts as an independent Serverless Function.
2.  **Instant Wake:** Functions wake up instantly upon request.
3.  **Auto-Scaling:** The infrastructure handles traffic spikes automatically.

### API Endpoints
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/login` | User authentication & Token generation |
| `GET` | `/api/employees` | Fetch all employees |
| `GET` | `/api/teams` | Fetch all teams |
| `GET` | `/api/employee/:id` | Get specific employee details |
| `GET` | `/api/team/:id` | Get specific team details |

---

## ⚙️ Core Features
* **User Authentication:** Secure login flow.
* **Employee CRUD:** Create, Read, Update, and Delete employee records.
* **Team Management:** Create teams and assign members.
* **Role Handling:** Distinction between Admin and Staff roles.
* **Security:**
    * Passwords hashed using `bcrypt`.
    * JWT tokens used for session management.
    * CORS protection enabled.
    * No sensitive data exposed in API responses.

## 🤝 Frontend Integration
This backend is consumed by the **React Frontend** hosted on Vercel. Both applications leverage Vercel's edge network for low-latency communication.

**Frontend Repository:** [HRMS Frontend](https://hrms-frontend-coral-mu.vercel.app/)

## 🗄️ Database Architecture (Turso)
The entire SQLite database (`hrms.db`) is hosted on **Turso’s Edge Network**.

🔗 **[View Database Schema & API Architecture (PDF)](https://drive.google.com/file/d/1B8aVPwmsypnaM6yVhIr4A2pHDCwiGi5I/view?usp=sharing)**


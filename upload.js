const { createClient } = require("@libsql/client");
const fs = require("fs");
require('dotenv').config(); 

const client = createClient({
  url: process.env.TURSO_DATABASE_URL,
  authToken: process.env.TURSO_AUTH_TOKEN,
});

async function uploadData() {
  try {
    console.log("📂 Reading dump.sql...");
    const rawSql = fs.readFileSync("dump.sql", "utf8");

    // 1. CLEANUP: Drop existing tables so we don't get "Duplicate ID" errors
    // We drop child tables first (like employee_teams) to be safe.
    const cleanupSql = `
      PRAGMA foreign_keys = OFF;
      DROP TABLE IF EXISTS employee_teams;
      DROP TABLE IF EXISTS logs;
      DROP TABLE IF EXISTS employees;
      DROP TABLE IF EXISTS teams;
      DROP TABLE IF EXISTS users;
      DROP TABLE IF EXISTS organisations;
    `;

    // 2. RESTORE: The actual upload logic
    const finalSql = `
      ${cleanupSql}
      
      ${rawSql}
      
      PRAGMA foreign_keys = ON;
    `;

    console.log("🧹 Cleaning up old data...");
    console.log("🚀 Uploading fresh data to Turso...");
    
    await client.executeMultiple(finalSql);

    console.log("✅ Success! Database restored successfully.");
  } catch (err) {
    console.error("❌ Error uploading:", err);
  }
}

uploadData();
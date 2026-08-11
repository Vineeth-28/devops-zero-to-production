const express = require("express");
const mysql = require("mysql2/promise");

const app = express();

const PORT = 3000;

const db = mysql.createPool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD
});

app.get("/", async (req, res) => {
    try {
        const [rows] = await db.query("SELECT 1 AS connected");

        res.json({
            message: "Backend is running!",
            database: rows[0].connected === 1 ? "Connected" : "Not Connected"
        });

    } catch (error) {
        console.error("Database connection failed:", error.message);

        res.status(500).json({
            message: "Database connection failed"
        });
    }
});

app.listen(PORT, () => {
    console.log(`Backend running on port ${PORT}`);
});
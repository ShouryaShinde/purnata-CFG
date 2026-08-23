import pool from "../config/db.js"

export const getUserByEmail = async (email) => {
    try {
        const result = await pool.query(
            `SELECT * FROM users WHERE email = $1`,
            [email]
        )
        return result.rows[0];
    } catch (err) {
        console.log("Error fetching user by email", err);
        throw err;
    }
}

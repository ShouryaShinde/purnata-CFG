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

//Get user by ID
export const getCurrentUser = async (userId) => {
    try {
        const result = await pool.query(
            `SELECT * FROM users WHERE id = $1`,
            [userId]
        )
        return result.rows[0];
    } catch (err) {
        console.log("Error fetching user by ID", err);
        throw err;
    }
}

//Get Volunteer by ID
export const getVolunteerById = async (volunteerId ) => {
    try { 
        const result = await pool.query(
            'SELECT * FROM volunteer_profiles WHERE id = $1',
            [volunteerId]
        )
        return result.rows[0];
    } catch (err) {
        console.log("Error fetching volunteer by ID", err);
        throw err;
    }
}

//Get Volunteers
export const getVolunteers = async({
    page = 1,
    limit = 10,
    status,
    skillId,
    search
}) => {
    let query = 'SELECT * FROM volunteer_profiles' ;

    if(status) {
        query += ` WHERE status = '${status}'`;
    }

    if(skillId) {
        query += status ? ` AND skill_id = ${skillId}` : ` WHERE skill_id = ${skillId}`;
    }

    if(search) {
        query += status || skillId ? ` AND name LIKE '%${search}%'` : ` WHERE name LIKE '%${search}%'`;
    }

    query += ` LIMIT ${limit} OFFSET ${(page - 1) * limit}`;

    try {
        const result = await pool.query(query);
        return result.rows;
    } catch (err) {
        console.log("Error fetching volunteers", err);
        throw err;
    }
}

//Update Volunteer Profile
export const updateVolunteer = async (volunteerId, bio, availability, status) => {
    const dateUpdated = new Date();

    const VolunteerAvailability = ['WEEKDAYS', 'WEEKENDS', 'BOTH', 'FLEXIBLE'];

    if (!VolunteerAvailability.includes(availability)) {
        throw new Error("Invalid availability value");
    }

    let query = 'UPDATE volunteer_profiles SET ';

    if(bio) {
        query += `bio = '${bio}', `;
    }

    if(availability) {
        query += `availability = '${availability}', `;
    }

    if(status) {
        query += `status = '${status}', `;
    }

    // Remove the trailing comma and space
    query = query.slice(0, -2);

    // Add the WHERE clause
    query += ` WHERE id = ${volunteerId}`;

    try {
        const result = await pool.query(query);
        return result.rows[0];
    } catch (err) {
        console.log("Error updating volunteer", err);
        throw err;
    }
}

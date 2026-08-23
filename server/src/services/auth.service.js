import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import { getUserByEmail } from "../models/user.model.js";

dotenv.config();

export const loginUser = async (email, password) => {
    const user = await getUserByEmail(email);

    if (!user) {
        throw new Error("Invalid Credentials");
    }

    const passwordMatch = await bcrypt.compare(password, user.password_hash);

    if (!passwordMatch) {
        throw new Error("Invalid Credentials");
    }

    if (user.status !== "ACTIVE") {
        throw new Error("User account is not active");
    }

    const token = jwt.sign(
        {
            userId: user.id,
            role: user.role
        },
        process.env.JWT_SECRET,
        {
            expiresIn: "1d"
        }
    );

    return {
        token,
        user: {
            id: user.id,
            email: user.email,
            role: user.role,
            status: user.status
        }
    };
}
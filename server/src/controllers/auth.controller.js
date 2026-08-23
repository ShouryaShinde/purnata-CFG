import { loginUser } from "../services/auth.service.js";

export const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ message: "Email and password are required" });
        }
        const result = await loginUser(email, password);
        return res.status(200).json({
            message: "Login successful",
            data: result
        });
    } catch (error) {
        if (error.message === "Invalid Credentials" || error.message === "User account is not active") {
            return res.status(401).json({ message: error.message });
        }
        res.status(500).json({ message: error.message });
    }
};
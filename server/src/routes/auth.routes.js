import express from "express";
import dotenv from "dotenv";
import { login } from "../controllers/auth.controller.js";
import { authenticate } from "../middlewares/authenticate.js";

dotenv.config();

const router = express.Router();

router.post("/login", login);

router.get("/me", authenticate, (req, res) => {
    res.status(200).json({
        success: true,
        user: req.user
    });
});

export default router;
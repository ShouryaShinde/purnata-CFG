import express from "express"
import {pool} from "pg"
import dotenv from "dotenv"
dotenv.config()

const pool = new pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

export default pool;
import express from 'express'
import mysql from 'mysql2'
import dotenv from 'dotenv'
// Config dotenv to enable environment variables
dotenv.config()

// Initialize express instance
const app = express()

const PORT = 3000

// create db connection -> using a pool to allow multiple queries without terminating connections
// Chaining the promise method to allow async functions instead of mysql callbacks
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  // password: process.env.DB_PW,
  database: process.env.DB
}).promise()


// Listen for connections on specified port. 
app.listen(PORT, () => {
  console.log('Listening on port', PORT)
})
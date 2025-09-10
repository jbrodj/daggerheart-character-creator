import { createConnection } from 'mysql2';
import { readFile } from 'fs';
import path from 'path';
// Config dotenv to enable environment variables
import dotenv from 'dotenv'
dotenv.config()

// Ref source: https://www.w3tutorials.net/blog/nodejs-execute-sql-file/

// Create connection
const connection = createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
})

connection.connect((err) => {
  if (err) throw err
  console.log('Connection established')
  connection.query('CREATE DATABASE IF NOT EXISTS dcc', (err, result) => {
    if (err) throw err
    console.log('DB Created', result)
  })
})

connection.query('USE dcc', (err, result) => {
  if (err) throw err
  console.log('Using dcc', result)
})

  // Read schema file to build tables
  const schemaFilePath = path.join('./db', 'schema_v1.sql')
  readFile(schemaFilePath, 'utf8', (err, sql) => {
      if (err) throw err

      // Split into individual statements and execute each
      const statements = sql.split(';').filter((statement) => statement.trim()!== '')
      statements.forEach((statement) => {
          connection.query(statement, (err, results) => {
              if (err) {
                  console.error('Error executing statement:', err)
              } else {
                  console.log('Statement executed successfully:', results)
              }
          })
      })
  })

  // Read the init file to populate tables with sample game data
  const sqlFilePath = path.join('./db', 'init-db.sql')
  readFile(sqlFilePath, 'utf8', (err, sql) => {
      if (err) throw err

      // Split into individual statements and run each
      const statements = sql.split(';').filter((statement) => statement.trim() !== '')
      statements.forEach((statement) => {
          connection.query(statement, (err, results) => {
              if (err) {
                  console.error('Error executing statement:', err)
              } else {
                  console.log('Statement executed successfully:', results)
              }
          })
      })
  })

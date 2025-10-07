import { createPool } from 'mysql2/promise'
import { readFile } from 'fs';
import path from 'path';
// Config dotenv to enable environment variables
import dotenv from 'dotenv'
dotenv.config()

const DB_SCHEMA_PATH = path.join('./db', 'schema_v1.sql')

// Ref source: 
  // https://www.w3tutorials.net/blog/nodejs-execute-sql-file/
  // https://sidorares.github.io/node-mysql2/docs/documentation/promise-wrapper


// Accepts an open file (from readFile) and returns list of statements.
export const getStatementsFromFile = (file) => {
  const statements = file.split(';').filter((statement) => statement.trim() !== '')
  return statements
}

// Accepts an individual SQL statement and the DB connection ref. Executes the statement.
export const executeStatement = async (statement, connection) => {
  try {
    await connection.query(statement)
  } catch (err) {
    console.error('Execution error: ', err)
  }
}

// Accepts path to a SQL file. Connects to DB, reads file, and executes all statements in SQL file. 
export const runSqlFile = async (filePath) => {
    const connection = createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: 'dcc'
  })
  const result = readFile(filePath, 'utf-8', (err, file) => {
    if (err) throw err 
    const statements = getStatementsFromFile(file)
    statements.forEach((statement) => {
      executeStatement(statement, connection)
    })
  }) 
  setTimeout(() => {
    connection.end()
  }, 500)
  return result
}


const runner = async () => {
  const conn = createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
  })
  let result
  try {
    result = await conn.query('CREATE DATABASE IF NOT EXISTS dcc')
  } catch (error) {
    console.error(error)
  }
  console.log(result[0])

  // Generate table schema from schema file
  await runSqlFile(DB_SCHEMA_PATH)

  conn.end()
}

runner()
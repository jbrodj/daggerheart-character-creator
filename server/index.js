import dotenv from 'dotenv'
import express from 'express'
import mysql from 'mysql2'

// Import error message copy
import errors from './errors.json' with { type: 'json' }
const { notFound, queryError, resourceError } = errors

// Initialize express instance
const app = express()

// Config dotenv to enable environment variables
dotenv.config()

const PORT = 3000

// create db connection -> using a pool to allow multiple queries without terminating connections
// Chaining the promise method to allow async functions instead of mysql callbacks
const pool = mysql
  .createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB,
  })
  .promise()

// Retrieves table schema. Takes table name as string.
const getSchema = async (tableName) => {
  try {
    const result = await pool.query('DESCRIBE' + pool.escapeId(tableName))
    // Result will be arr of objects, first is result, second is metadata. We only need the first index.
    return result[0]
  } catch (error) {
    console.error(error)
    return { message: resourceError }
  }
}

// Retrieves a single or set of resources from the game rules tables
// Takes tableName STR, and optionally a columnName STR and columnValue STR:
// SELECT [columnName or *] FROM [tableName] (Optionally: WHERE columnName = columnValue)
const getResource = async (tableName, columnName, columnValue) => {
  // Select specific resource queries if a column name is specified
  if (columnName) {
    try {
      const result = await pool.query(
        'SELECT * FROM' +
          pool.escapeId(tableName) +
          'WHERE' +
          pool.escapeId(columnName) +
          '=' +
          pool.escape(columnValue),
      )
      return result[0]
    } catch (error) {
      console.error(error)
      return { message: resourceError }
    }
  }
  // Select all queries
  try {
    const result = await pool.query('SELECT * FROM' + pool.escapeId(tableName))
    return result[0]
  } catch (error) {
    console.error(error)
    return { message: resourceError }
  }
}

// Get table schema by table name -- for testing
// Spec: /schema/?table=<tableName>
app.get('/schema/', async (req, res) => {
  const query = req._parsedUrl.query
  const tableKeyStr = 'table='
  // URL must include query with table name
  if (!query || !query.includes(tableKeyStr)) {
    const error = { message: queryError }
    res.send(error)
    return
  }
  // Find query value by locating the `table` key
  const queryValue = query.substring(
    query.indexOf(tableKeyStr) + tableKeyStr.length,
  )
  let result

  try {
    result = await getSchema(queryValue)
  } catch (error) {
    result = error
  }
  res.send(result)
})

// Get all resources by table name (or get all columns for a specified row by table, column & value)
// Spec: /resource/?table=<tableValue>&<columnKey>=<columnValue>
app.get('/resource/', async (req, res) => {
  const query = req.originalUrl
  const tableKeyStr = 'table='
  const hasColumnQueryParam = query.includes('&')
  // Table name substring either ends at the start of the next query param (if it exists), else at end of url.
  const tableQueryEndIndex = hasColumnQueryParam
    ? query.indexOf('&')
    : query.length
  const tableValue = query.substring(
    query.indexOf(tableKeyStr) + tableKeyStr.length,
    tableQueryEndIndex,
  )
  const columnQuery = query.substring(tableQueryEndIndex + 1)
  const keyValSeparatorIndex = columnQuery.indexOf('=')
  // Column key and value can be passed as empty strings if there is no param present
  const columnKey = hasColumnQueryParam
    ? columnQuery.substring(0, keyValSeparatorIndex)
    : ''
  const columnValue = hasColumnQueryParam
    ? columnQuery.substring(keyValSeparatorIndex + 1).replaceAll('+', ' ')
    : ''
  let result

  try {
    result = await getResource(tableValue, columnKey, columnValue)
    // If no row exists with specified params, result will be empty array. Handle empty array case.
    if (result.length == 0) {
      result = { message: notFound }
    }
  } catch (error) {
    result = error
  }
  res.send(result)
})

// Listen for connections on specified port.
app.listen(PORT, () => {
  console.log('Listening on port', PORT)
})

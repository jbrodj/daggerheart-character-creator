import express from 'express'

// Initialize express instance
const app = express()

const PORT = 3000

// Listen for connections on specified port. 
app.listen(PORT, () => {
  console.log('hieeeee')
})
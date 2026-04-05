require('dotenv').config();
const pool = require('./db');
const express = require('express');
const app = express();

app.use(express.json());

// Test route
app.get('/', (req, res) => {
  res.send('API is running 🚀');
});



app.get('/test-db', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Example API endpoint
app.get('/users', (req, res) => {
  res.json([
    { id: 1, name: 'Andre' },
    { id: 2, name: 'John' }
  ]);
});



const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

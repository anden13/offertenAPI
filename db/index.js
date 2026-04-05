const { Pool } = require('pg');
const { DefaultAzureCredential } = require('@azure/identity');

// Reuse one credential instance.
// Azure Identity is designed so token refresh/caching is handled by the library.
const credential = new DefaultAzureCredential();

async function getPgAccessToken() {
  const token = await credential.getToken(
    'https://ossrdbms-aad.database.windows.net/.default'
  );

  if (!token || !token.token) {
    throw new Error('Failed to acquire Azure PostgreSQL access token');
  }

  return token.token;
}

const pool = new Pool({
  host: process.env.DB_HOST,          // e.g. your-server.postgres.database.azure.com
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || 'postgres',
  user: process.env.DB_USER,          // your Entra user/group/app identity mapped in Postgres
  password: async () => {
    return await getPgAccessToken();
  },
  ssl: {
    rejectUnauthorized: false
  },

  // Helps rotate connections instead of keeping them forever
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
  max: 10
});

pool.on('error', (err) => {
  console.error('Unexpected PostgreSQL pool error:', err);
});

module.exports = pool;
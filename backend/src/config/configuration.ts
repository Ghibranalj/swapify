export default () => ({
  port: parseInt(process.env.PORT ?? '3000', 10),
  database: {
    path: process.env.DATABASE_PATH || './swapify.db',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'swapify-dev-secret-key',
    expiresIn: parseInt(process.env.JWT_EXPIRATION ?? '3600', 10),
  },
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID || '',
  },
  minio: {
    endpoint: process.env.MINIO_ENDPOINT || 'localhost',
    port: parseInt(process.env.MINIO_PORT ?? '9000', 10),
    accessKey: process.env.MINIO_ACCESS_KEY || 'minioadmin',
    secretKey: process.env.MINIO_SECRET_KEY || 'minioadmin',
    bucket: process.env.MINIO_BUCKET || 'swapify',
    useSSL: process.env.MINIO_USE_SSL === 'true',
  },
});

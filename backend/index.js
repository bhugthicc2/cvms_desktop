require("dotenv").config();

const app = require("./src/app");
const sanctionsRoutes = require("./src/routes/sanctions.routes");

// Mount sanctions routes
app.use("/api/sanctions", sanctionsRoutes);

// Graceful shutdown handling
const gracefulShutdown = (signal) => {
  console.log(`\n[${new Date().toISOString()}] Received ${signal}. Starting graceful shutdown...`);
  
  // Close server and cleanup
  server.close(() => {
    console.log(`[${new Date().toISOString()}] HTTP server closed.`);
    process.exit(0);
  });

  // Force close after 30 seconds
  setTimeout(() => {
    console.error(`[${new Date().toISOString()}] Could not close connections in time, forcefully shutting down`);
    process.exit(1);
  }, 30000);
};

// Start server
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

const server = app.listen(PORT, HOST, () => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] 🚀 CVMS Sanction API Server started successfully`);
  console.log(`[${timestamp}] 📍 Server running on http://${HOST}:${PORT}`);
  console.log(`[${timestamp}] 🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`[${timestamp}] 📊 Health check: http://${HOST}:${PORT}/health`);
  console.log(`[${timestamp}] 🔧 Sanctions API: http://${HOST}:${PORT}/api/sanctions/health`);
});

// Handle process signals
process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Handle uncaught exceptions
process.on('uncaughtException', (error) => {
  console.error(`[${new Date().toISOString()}] Uncaught Exception:`, error);
  process.exit(1);
});

// Handle unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
  console.error(`[${new Date().toISOString()}] Unhandled Rejection at:`, promise, 'reason:', reason);
  process.exit(1);
});

const express = require("express");
const cors = require("cors");

const violationRoutes = require("./routes/violations.routes");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/violations", violationRoutes);

// Health check endpoint
app.get("/health", (req, res) => {
  res.json({ status: "OK", timestamp: new Date().toISOString() });
});

module.exports = app;

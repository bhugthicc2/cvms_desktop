const express = require("express");
const {
  applySanctionForViolation,
} = require("../services/sanction.service");

const router = express.Router();

router.post("/confirm", async (req, res) => {
  const { violationId } = req.body;

  if (!violationId) {
    return res.status(400).json({ error: "violationId is required" });
  }

  try {
    await applySanctionForViolation(violationId);
    res.json({ success: true });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

module.exports = router;

const express = require("express");
const { db } = require("../firebase/admin");
const router = express.Router();

// Validation middleware
const validateSanctionRequest = (req, res, next) => {
  const { violationId, vehicleId, confirmedBy } = req.body;

  // Check required fields
  if (!violationId || typeof violationId !== 'string' || violationId.trim().length === 0) {
    return res.status(400).json({
      error: "Bad Request",
      message: "violationId is required and must be a non-empty string",
      timestamp: new Date().toISOString()
    });
  }

  if (!vehicleId || typeof vehicleId !== 'string' || vehicleId.trim().length === 0) {
    return res.status(400).json({
      error: "Bad Request", 
      message: "vehicleId is required and must be a non-empty string",
      timestamp: new Date().toISOString()
    });
  }

  if (!confirmedBy || typeof confirmedBy !== 'string' || confirmedBy.trim().length === 0) {
    return res.status(400).json({
      error: "Bad Request",
      message: "confirmedBy is required and must be a non-empty string", 
      timestamp: new Date().toISOString()
    });
  }

  // Sanitize inputs
  req.body = {
    violationId: violationId.trim(),
    vehicleId: vehicleId.trim(),
    confirmedBy: confirmedBy.trim()
  };

  next();
};

// POST /api/sanctions/from-violation
router.post("/from-violation", validateSanctionRequest, async (req, res) => {
  const { violationId, vehicleId, confirmedBy } = req.body;
  
  try {
    console.log(`[SANCTION] Processing sanction request: violationId=${violationId}, vehicleId=${vehicleId}, confirmedBy=${confirmedBy}`);

    // 1. Verify violation exists and is confirmed
    const violationDoc = await db.collection("violations").doc(violationId).get();
    if (!violationDoc.exists) {
      return res.status(404).json({
        error: "Not Found",
        message: "Violation not found",
        timestamp: new Date().toISOString()
      });
    }

    const violationData = violationDoc.data();
    if (violationData.status !== "confirmed") {
      return res.status(400).json({
        error: "Bad Request",
        message: "Violation must be confirmed before creating sanction",
        timestamp: new Date().toISOString()
      });
    }

    // Check if sanction already applied
    if (violationData.sanctionApplied) {
      return res.status(409).json({
        error: "Conflict",
        message: "Sanction already applied to this violation",
        timestamp: new Date().toISOString()
      });
    }

    // 2. Count confirmed violations for this vehicle
    const violationsSnap = await db
      .collection("violations")
      .where("vehicleId", "==", vehicleId)
      .where("status", "==", "confirmed")
      .get();

    const offenseNumber = violationsSnap.size;
    console.log(`[SANCTION] Vehicle ${vehicleId} has ${offenseNumber} confirmed violations`);

    // 3. Determine sanction type
    let sanctionType = "warning";
    let vehicleStatus = "active";
    let endAt = null;

    if (offenseNumber === 2) {
      sanctionType = "suspension";
      vehicleStatus = "suspended";
      // 30 working days (42 calendar days)
      endAt = new Date(Date.now() + 42 * 24 * 60 * 60 * 1000);
    } else if (offenseNumber >= 3) {
      sanctionType = "revocation";
      vehicleStatus = "revoked";
    }

    // 4. Create sanction record using transaction for data consistency
    const sanctionRef = await db.runTransaction(async (transaction) => {
      // Create sanction record
      const newSanctionRef = db.collection("sanctions").doc();
      
      const sanctionData = {
        violationId,
        vehicleId,
        offenseNumber,
        type: sanctionType,
        status: sanctionType === "warning" ? "completed" : "active",
        startAt: new Date(),
        endAt: endAt,
        createdBy: confirmedBy,
        createdAt: new Date(),
        lastEvaluatedAt: null
      };

      transaction.set(newSanctionRef, sanctionData);

      // Update vehicle status if needed
      if (vehicleStatus !== "active") {
        const vehicleRef = db.collection("vehicles").doc(vehicleId);
        transaction.update(vehicleRef, {
          registrationStatus: vehicleStatus,
          updatedAt: new Date()
        });
      }

      // Mark violation as sanctioned
      transaction.update(violationDoc.ref, {
        sanctionApplied: true,
        sanctionId: newSanctionRef.id,
        sanctionedAt: new Date()
      });

      return newSanctionRef;
    });

    console.log(`[SANCTION] Successfully created sanction: ${sanctionRef.id} for vehicle ${vehicleId}`);

    res.status(201).json({
      success: true,
      sanctionType,
      offenseNumber,
      sanctionId: sanctionRef.id,
      vehicleStatus,
      endAt: endAt ? endAt.toISOString() : null,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error(`[SANCTION] Error processing sanction: ${error.message}`, {
      violationId,
      vehicleId,
      confirmedBy,
      stack: error.stack
    });

    // Handle specific Firebase errors
    if (error.code === 'permission-denied') {
      return res.status(403).json({
        error: "Forbidden",
        message: "Insufficient permissions to perform this operation",
        timestamp: new Date().toISOString()
      });
    }

    if (error.code === 'not-found') {
      return res.status(404).json({
        error: "Not Found", 
        message: "Required document not found",
        timestamp: new Date().toISOString()
      });
    }

    res.status(500).json({
      error: "Internal Server Error",
      message: "Failed to process sanction request",
      timestamp: new Date().toISOString()
    });
  }
});

// GET /api/sanctions/health
router.get("/health", (req, res) => {
  res.json({
    status: "OK",
    service: "sanctions-api",
    timestamp: new Date().toISOString()
  });
});

module.exports = router;

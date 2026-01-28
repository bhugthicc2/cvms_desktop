const { admin, db } = require("../firebase/admin");
const { addWorkingDays } = require("../utils/date.utils");

async function applySanctionForViolation(violationId) {
  await db.runTransaction(async (tx) => {
    const violationRef = db.collection("violations").doc(violationId);
    const violationSnap = await tx.get(violationRef);

    if (!violationSnap.exists) {
      throw new Error("Violation not found");
    }

    const violation = violationSnap.data();
    if (violation.status === "confirmed") return;

    const vehicleId = violation.vehicleId;

    // Confirm violation
    tx.update(violationRef, {
      status: "confirmed",
      confirmedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Count confirmed violations
    const offensesSnap = await tx.get(
      db
        .collection("violations")
        .where("vehicleId", "==", vehicleId)
        .where("status", "==", "confirmed")
    );

    const offenseCount = offensesSnap.size;

    let sanctionType = null;
    let vehicleStatus = "active";
    let endAt = null;

    if (offenseCount === 1) {
      sanctionType = "warning";
    } else if (offenseCount === 2) {
      sanctionType = "suspension";
      vehicleStatus = "suspended";
      endAt = addWorkingDays(new Date(), 30);
    } else if (offenseCount >= 3) {
      sanctionType = "revocation";
      vehicleStatus = "revoked";
    }

    if (!sanctionType) return;

    const sanctionRef = db.collection("sanctions").doc();

    tx.set(sanctionRef, {
      vehicleId,
      violationId,
      type: sanctionType,
      status: "active",
      offenseNumber: offenseCount,
      startAt: admin.firestore.FieldValue.serverTimestamp(),
      endAt: endAt
        ? admin.firestore.Timestamp.fromDate(endAt)
        : null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    tx.update(db.collection("vehicles").doc(vehicleId), {
      registrationStatus: vehicleStatus,
    });
  });
}

module.exports = { applySanctionForViolation };

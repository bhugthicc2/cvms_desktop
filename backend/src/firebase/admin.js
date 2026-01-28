const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.cert(require("./service-account.json")),
});

const db = admin.firestore();

module.exports = { admin, db };

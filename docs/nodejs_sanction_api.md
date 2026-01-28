# Node.js Sanction API Documentation

## Overview

This document describes the Node.js backend implementation for the CVMS (Cloud-based Vehicle Monitoring System) sanction processing API. The API handles automatic sanction creation based on confirmed violations for vehicles.

## Architecture

### File Structure

```
backend/
├── index.js                    # Main server entry point
├── src/
│   ├── app.js                 # Express app configuration
│   └── firebase/
│       ├── admin.js           # Firebase Admin SDK setup
│       └── service-account.json # Firebase service credentials
├── .env                       # Environment variables
└── package.json               # Dependencies and scripts
```

### Dependencies

- **express**: Web framework for Node.js
- **cors**: Cross-Origin Resource Sharing middleware
- **firebase-admin**: Firebase Admin SDK for Firestore operations
- **dotenv**: Environment variable management

## API Endpoints

### POST /sanctions/from-violation

Automatically creates sanctions based on confirmed violations for a vehicle.

#### Request Body

```json
{
  "violationId": "string", // ID of the violation being processed
  "vehicleId": "string", // ID of the vehicle
  "confirmedBy": "string" // ID of the admin who confirmed the violation
}
```

#### Response

**Success (200 OK)**

```json
{
  "success": true,
  "sanctionType": "warning|suspension|revocation",
  "offenseNumber": 0
}
```

**Error (400 Bad Request)**

```json
{
  "error": "Missing data"
}
```

**Error (500 Internal Server Error)**

```json
{
  "error": "Sanction processing failed",
  "details": "Error message",
  "stack": "Error stack trace"
}
```

### GET /health

Health check endpoint to verify server status.

#### Response

```json
{
  "status": "OK",
  "timestamp": "2026-01-28T17:24:02.765Z"
}
```

## Sanction Logic

The API implements a progressive sanction system based on the number of confirmed violations:

### Offense Count and Sanctions

| Offense Number | Sanction Type | Vehicle Status | Duration                  |
| -------------- | ------------- | -------------- | ------------------------- |
| 1              | Warning       | Active         | N/A                       |
| 2              | Suspension    | Suspended      | 42 days (30 working days) |
| 3+             | Revocation    | Revoked        | Permanent                 |

### Processing Flow

1. **Validation**: Check if required fields are present
2. **Count Violations**: Query Firestore for confirmed violations for the vehicle
3. **Determine Sanction**: Apply sanction logic based on offense count
4. **Create Sanction Record**: Store sanction details in Firestore
5. **Update Vehicle Status**: Change vehicle registration status if needed
6. **Mark Violation**: Update violation with sanction information

## Database Operations

### Firestore Collections

#### violations

```javascript
// Query for confirmed violations
db.collection("violations")
  .where("vehicleId", "==", vehicleId)
  .where("status", "==", "confirmed")
  .get();
```

#### sanctions

```javascript
// Create sanction record
await db.collection("sanctions").add({
  violationId,
  vehicleId,
  offenseNumber,
  type: sanctionType,
  status: sanctionType === "warning" ? "completed" : "active",
  startAt: admin.firestore.FieldValue.serverTimestamp(),
  endAt, // null for warnings/revocations, timestamp for suspensions
  createdBy: confirmedBy,
  createdAt: admin.firestore.FieldValue.serverTimestamp(),
});
```

#### vehicles

```javascript
// Update vehicle status (if not active)
await db.collection("vehicles").doc(vehicleId).update({
  registrationStatus: vehicleStatus,
});
```

## Error Handling

### Document Existence Check

The API safely handles cases where violation documents don't exist:

```javascript
const violationDoc = await violationRef.get();
if (violationDoc.exists) {
  await violationRef.update({
    sanctionApplied: true,
    sanctionId: sanctionRef.id,
  });
} else {
  console.warn(`Violation document ${violationId} not found, skipping update`);
}
```

### Error Logging

Detailed error logging includes:

- Error message and stack trace
- Request context and data
- Step-by-step processing status

## Environment Configuration

### Required Environment Variables

```env
PORT=3000
FIREBASE_SERVICE_ACCOUNT={"type":"service_account",...}
```

### Firebase Setup

1. Create a Firebase service account key
2. Save credentials to `src/firebase/service-account.json`
3. Ensure the service account has Firestore permissions

## Security Considerations

### CORS Configuration

The API uses CORS middleware to allow cross-origin requests:

```javascript
app.use(cors());
```

### Input Validation

Basic validation ensures required fields are present:

```javascript
if (!violationId || !vehicleId) {
  return res.status(400).json({ error: "Missing data" });
}
```

### Firebase Security

- Service account credentials are stored separately from source code
- Firebase Admin SDK provides secure database access
- Server-side operations bypass client-side security rules

## Deployment

### Local Development

```bash
# Install dependencies
npm install

# Start development server
node index.js
```

### Production Considerations

- Use environment variables for configuration
- Implement proper logging and monitoring
- Set up Firebase security rules for additional protection
- Consider rate limiting for API endpoints

## Integration with CVMS Frontend

The API is called from the Flutter frontend when violations are confirmed:

```dart
// In violation_repository.dart
await triggerSanction(
  violationId: violationId,
  vehicleId: vehicleId,
  adminUserId: confirmedByUserId,
);
```

## Testing

### Health Check

```bash
curl http://localhost:3000/health
```

### Sanction Processing

```bash
curl -X POST http://localhost:3000/sanctions/from-violation \
  -H "Content-Type: application/json" \
  -d '{
    "violationId": "test-violation-id",
    "vehicleId": "test-vehicle-id",
    "confirmedBy": "admin-user-id"
  }'
```

## Troubleshooting

### Common Issues

1. **Firebase Connection Errors**: Verify service account credentials
2. **Missing Documents**: Check if violation/vehicle documents exist
3. **Permission Errors**: Ensure Firebase service account has proper permissions
4. **Port Conflicts**: Check if port 3000 is available

### Debug Mode

For detailed logging, use the debug server implementation with step-by-step console output.

## Future Enhancements

- Add input validation with Joi or similar library
- Implement rate limiting
- Add API authentication/authorization
- Create comprehensive unit tests
- Add monitoring and alerting
- Implement retry logic for Firestore operations

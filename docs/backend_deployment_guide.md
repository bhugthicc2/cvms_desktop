# CVMS Backend Deployment Guide

## Overview

This guide covers deploying the CVMS Sanction Management API to production environments like Railway, Heroku, or any cloud platform supporting Node.js applications.

## Prerequisites

- Node.js 18+ runtime
- Firebase project with Admin SDK configured
- Environment variables for Firebase credentials
- Git repository with the backend code

## Environment Variables

### Required Variables

```bash
# Server Configuration
NODE_ENV=production
PORT=3000
HOST=0.0.0.0

# CORS Configuration
ALLOWED_ORIGINS=https://yourapp.com,https://admin.yourapp.com

# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project-id.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n"
FIREBASE_PRIVATE_KEY_ID=your-private-key-id
FIREBASE_CLIENT_ID=your-client-id
FIREBASE_CLIENT_X509_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xxxxx%40your-project-id.iam.gserviceaccount.com
```

### Optional Variables

```bash
LOG_LEVEL=info
```

## Deployment Platforms

### Railway

1. **Create Railway Account**
   - Sign up at [railway.app](https://railway.app)
   - Connect your GitHub repository

2. **Configure Environment Variables**

   ```bash
   # In Railway dashboard, add all required environment variables
   NODE_ENV=production
   PORT=3000
   # ... add all Firebase variables
   ```

3. **Deploy**
   - Railway will automatically detect the Node.js application
   - The `railway.toml` file provides deployment configuration
   - Health checks are automatically configured

4. **Verify Deployment**
   ```bash
   curl https://your-app.railway.app/health
   curl https://your-app.railway.app/api/sanctions/health
   ```

### Docker Deployment

1. **Build Docker Image**

   ```bash
   cd backend
   docker build -t cvms-sanction-api .
   ```

2. **Run Container**

   ```bash
   docker run -d \
     --name cvms-api \
     -p 3000:3000 \
     --env-file .env \
     cvms-sanction-api
   ```

3. **Docker Compose (Optional)**
   ```yaml
   version: "3.8"
   services:
     cvms-api:
       build: .
       ports:
         - "3000:3000"
       env_file:
         - .env
       restart: unless-stopped
       healthcheck:
         test:
           [
             "CMD",
             "node",
             "-e",
             "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })",
           ]
         interval: 30s
         timeout: 10s
         retries: 3
   ```

### Generic Cloud Platform (Heroku, DigitalOcean, etc.)

1. **Install Dependencies**

   ```bash
   npm install --production
   ```

2. **Set Environment Variables**

   ```bash
   export NODE_ENV=production
   export PORT=3000
   # ... set all Firebase variables
   ```

3. **Start Application**
   ```bash
   npm start
   ```

## API Endpoints

### Health Checks

- **General Health**: `GET /health`
- **Sanctions API**: `GET /api/sanctions/health`

### Sanctions API

- **Create Sanction**: `POST /api/sanctions/from-violation`

#### Request Body

```json
{
  "violationId": "string",
  "vehicleId": "string",
  "confirmedBy": "string"
}
```

#### Response (201 Created)

```json
{
  "success": true,
  "sanctionType": "warning|suspension|revocation",
  "offenseNumber": 1,
  "sanctionId": "sanction-document-id",
  "vehicleStatus": "active|suspended|revoked",
  "endAt": "2024-12-31T23:59:59.000Z",
  "timestamp": "2024-01-28T17:24:02.765Z"
}
```

## Security Considerations

### Firebase Security Rules

Ensure your Firestore security rules are properly configured:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Sanctions collection - admin only
    match /sanctions/{sanctionId} {
      allow read, write: if request.auth != null &&
        request.auth.token.admin == true;
    }

    // Vehicles collection - status updates only
    match /vehicles/{vehicleId} {
      allow write: if request.auth != null &&
        request.auth.token.admin == true &&
        request.resource.data.keys().hasAll(['registrationStatus', 'updatedAt']);
      allow read: if request.auth != null;
    }

    // Violations collection - sanctionApplied field only
    match /violations/{violationId} {
      allow write: if request.auth != null &&
        request.auth.token.admin == true &&
        request.resource.data.keys().hasAll(['sanctionApplied', 'sanctionId', 'sanctionedAt']);
      allow read: if request.auth != null;
    }
  }
}
```

### API Security

- **CORS**: Configured for specific origins in production
- **Input Validation**: All request payloads are validated
- **Rate Limiting**: Consider implementing rate limiting for production
- **HTTPS**: Always use HTTPS in production
- **Environment Variables**: Never commit secrets to version control

## Monitoring and Logging

### Application Logs

The application provides structured logging:

```bash
[2024-01-28T17:24:02.765Z] 🚀 CVMS Sanction API Server started successfully
[2024-01-28T17:24:02.765Z] 📍 Server running on http://0.0.0.0:3000
[2024-01-28T17:24:02.765Z] 🌍 Environment: production
[2024-01-28T17:24:02.765Z] 📊 Health check: http://0.0.0.0:3000/health
[2024-01-28T17:24:02.765Z] 🔧 Sanctions API: http://0.0.0.0:3000/api/sanctions/health
[2024-01-28T17:25:15.123Z] POST /api/sanctions/from-violation - IP: 192.168.1.100 - User-Agent: CVMS-Flutter-App/1.0
[2024-01-28T17:25:15.456Z] [SANCTION] Processing sanction request: violationId=abc123, vehicleId=def456, confirmedBy=admin123
[2024-01-28T17:25:15.789Z] [SANCTION] Successfully created sanction: xyz789 for vehicle def456
```

### Health Monitoring

- **Health Endpoint**: Returns server status, uptime, and environment
- **Container Health**: Docker health checks every 30 seconds
- **Railway Health**: Automatic health monitoring with restart on failure

## Flutter Client Configuration

Update your Flutter app to use the production API URL:

```dart
// In lib/features/sanction_management/repository/node_repository.dart
final response = await triggerSanction(
  violationId: violationId,
  vehicleId: vehicleId,
  adminUserId: adminUserId,
  baseUrl: 'https://your-app.railway.app', // Production URL
);
```

## Troubleshooting

### Common Issues

1. **Firebase Connection Errors**
   - Verify environment variables are set correctly
   - Check Firebase service account permissions
   - Ensure private key format is correct (with \n line breaks)

2. **CORS Errors**
   - Verify `ALLOWED_ORIGINS` includes your Flutter app domain
   - Check that requests are made over HTTPS in production

3. **Deployment Failures**
   - Check build logs for missing dependencies
   - Verify Node.js version compatibility (18+)
   - Ensure all environment variables are set

4. **Health Check Failures**
   - Verify the server is listening on the correct port
   - Check firewall settings
   - Ensure HOST is set to `0.0.0.0` for containerized deployments

### Debug Mode

For debugging, you can temporarily enable development mode:

```bash
NODE_ENV=development npm start
```

This will provide more detailed error messages and stack traces.

## Production Checklist

- [ ] All environment variables configured
- [ ] Firebase service account has proper permissions
- [ ] CORS origins configured for production domains
- [ ] Health checks passing
- [ ] HTTPS enabled
- [ ] Monitoring/logging configured
- [ ] Error handling tested
- [ ] Rate limiting implemented (if needed)
- [ ] Backup strategy for Firestore data
- [ ] Security rules reviewed and tested

## Scaling Considerations

- **Horizontal Scaling**: The application is stateless and can be scaled horizontally
- **Database Scaling**: Consider Firestore usage patterns and optimize queries
- **Caching**: Implement caching for frequently accessed data
- **Load Balancing**: Use platform load balancers for high availability

## Support

For deployment issues:

1. Check application logs
2. Verify environment variables
3. Test health endpoints
4. Review Firebase configuration
5. Consult platform-specific documentation

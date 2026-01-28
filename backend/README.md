# CVMS Sanction API

Backend API for CVMS (Cloud-based Vehicle Monitoring System) sanction management.

## 🚀 Features

- **Automatic Sanction Creation** - Creates sanctions based on confirmed violations
- **Progressive Sanction System** - Warning → Suspension → Revocation
- **Real-time Vehicle Status Updates** - Updates vehicle registration status
- **Production-Ready** - Docker and Railway deployment support
- **Secure Firebase Integration** - Server-side Firebase Admin SDK
- **Comprehensive Error Handling** - Proper HTTP status codes and validation
- **Health Monitoring** - Built-in health checks and logging

## 📡 API Endpoints

### Health Checks

- `GET /health` - General health check
- `GET /api/sanctions/health` - Sanctions API health check

### Sanctions

- `POST /api/sanctions/from-violation` - Create sanction from violation

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

## 🛠️ Technology Stack

- **Node.js** 18+ - Runtime environment
- **Express.js** - Web framework
- **Firebase Admin SDK** - Database and authentication
- **Docker** - Containerization
- **Railway** - Deployment platform

## 🚀 Quick Start

### Local Development

1. **Clone the repository**

   ```bash
   git clone https://github.com/bhugthicc2/cvms-sanction-api.git
   cd cvms-sanction-api
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Set up environment variables**

   ```bash
   cp .env.example .env
   # Edit .env with your Firebase credentials
   ```

4. **Start the server**

   ```bash
   npm run dev
   ```

5. **Test the API**
   ```bash
   curl http://localhost:3000/health
   ```

### Railway Deployment

1. **Connect your GitHub repository** to [Railway](https://railway.app)
2. **Configure environment variables** in Railway dashboard
3. **Deploy** - Railway will automatically detect and deploy the Node.js app

### Docker Deployment

1. **Build the image**

   ```bash
   docker build -t cvms-sanction-api .
   ```

2. **Run the container**
   ```bash
   docker run -d \
     --name cvms-api \
     -p 3000:3000 \
     --env-file .env \
     cvms-sanction-api
   ```

## ⚙️ Configuration

### Environment Variables

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

## 📋 Sanction Logic

The API implements a progressive sanction system:

| Offense Count | Sanction Type | Vehicle Status | Duration        |
| ------------- | ------------- | -------------- | --------------- |
| 1             | Warning       | Active         | N/A             |
| 2             | Suspension    | Suspended      | 30 working days |
| 3+            | Revocation    | Revoked        | Permanent       |

## 🔒 Security

- **Environment Variables** - All secrets stored in environment variables
- **CORS Protection** - Configurable origin validation
- **Input Validation** - All request payloads validated
- **Firebase Security** - Server-side Firebase Admin SDK only
- **Error Handling** - No sensitive data leaked in production responses

## 📊 Monitoring

### Health Checks

- **Application Health**: `/health` - Returns server status and uptime
- **API Health**: `/api/sanctions/health` - API-specific health check
- **Docker Health**: Built-in container health monitoring

### Logging

Structured logging with timestamps and request context:

```
[2024-01-28T17:24:02.765Z] 🚀 CVMS Sanction API Server started successfully
[2024-01-28T17:24:02.765Z] 📍 Server running on http://0.0.0.0:3000
[2024-01-28T17:25:15.123Z] POST /api/sanctions/from-violation - IP: 192.168.1.100
[2024-01-28T17:25:15.456Z] [SANCTION] Processing sanction request: violationId=abc123
```

## 🔧 Development

### Scripts

```bash
npm start          # Start production server
npm run dev        # Start development server
npm run health     # Health check
```

### Project Structure

```
backend/
├── src/
│   ├── app.js                 # Express app configuration
│   ├── firebase/
│   │   └── admin.js           # Firebase Admin SDK setup
│   └── routes/
│       ├── sanctions.routes.js # Sanctions API routes
│       └── violations.routes.js # Violations API routes
├── docs/
│   └── backend_deployment_guide.md
├── .env.example               # Environment variables template
├── Dockerfile                 # Docker configuration
├── railway.toml              # Railway deployment config
├── package.json              # Dependencies and scripts
└── README.md                 # This file
```

## 📚 Documentation

- [Deployment Guide](docs/backend_deployment_guide.md) - Detailed deployment instructions
- [API Documentation](docs/nodejs_sanction_api.md) - Complete API reference

## 🔗 Integration

### Flutter Client

```dart
import 'package:cvms_desktop/features/sanction_management/repository/node_repository.dart';

final response = await triggerSanction(
  violationId: 'violation-123',
  vehicleId: 'vehicle-456',
  adminUserId: 'admin-789',
  baseUrl: 'https://your-app.railway.app',
);
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the ISC License.

## 🆘 Support

For deployment issues:

1. Check the [deployment guide](docs/backend_deployment_guide.md)
2. Review environment variables configuration
3. Test health endpoints
4. Check application logs

---

**CVMS Development Team** | Cloud-based Vehicle Monitoring System

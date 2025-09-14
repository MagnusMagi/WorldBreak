# Deployment Guide 🚀

This guide covers the deployment process for NewsLocal application, including both iOS app and backend services.

## 📱 iOS App Deployment

### **Prerequisites**
- **Xcode 15.0+** with latest iOS SDK
- **Apple Developer Account** (paid membership required)
- **Certificates & Provisioning Profiles** configured
- **App Store Connect** access

### **Build Configuration**

#### **1. Release Configuration**
```swift
// Build Settings
- Debug Information Format: DWARF with dSYM File
- Optimization Level: Fastest, Smallest [-Os]
- Strip Debug Symbols: YES
- Enable Bitcode: YES
- Code Signing: Automatic
```

#### **2. App Store Build Process**
```bash
# 1. Clean build folder
⌘ + Shift + K

# 2. Archive for App Store
Product → Archive

# 3. Upload to App Store Connect
Organizer → Distribute App → App Store Connect
```

#### **3. TestFlight Distribution**
```bash
# 1. Create TestFlight build
App Store Connect → TestFlight → iOS

# 2. Add test users
Internal Testing → Add Testers

# 3. External testing (if needed)
External Testing → Add Testers
```

### **App Store Submission**

#### **1. App Store Connect Setup**
- **App Information**: Name, description, keywords
- **Pricing**: Free/Paid model
- **Availability**: Release date and regions
- **App Review**: Submit for review

#### **2. Metadata Requirements**
```
App Name: NewsLocal
Subtitle: Modern News Experience
Description: 
NewsLocal brings you the latest news with a modern, 
personalized experience. Stay informed with real-time 
updates, AI-powered recommendations, and offline reading.

Keywords: news,breaking,local,personalized,offline
Category: News
Age Rating: 4+ (No Objectionable Content)
```

#### **3. Screenshots Requirements**
- **iPhone**: 6.7", 6.5", 5.5" displays
- **iPad**: 12.9" and 11" displays
- **App Preview Videos**: Optional but recommended

### **Release Management**

#### **Version Strategy**
```
Major.Minor.Patch (Semantic Versioning)
1.0.0 - Initial release
1.1.0 - New features
1.1.1 - Bug fixes
2.0.0 - Breaking changes
```

#### **Release Checklist**
- [ ] All features tested
- [ ] Performance optimized
- [ ] Crash-free for 7 days
- [ ] App Store guidelines compliance
- [ ] Metadata updated
- [ ] Screenshots current
- [ ] Release notes prepared

## 🖥️ Backend Deployment

### **Infrastructure Options**

#### **Option 1: AWS Deployment**
```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=${REDIS_URL}
    depends_on:
      - redis
      - postgres

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_DB=newslocal
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

#### **Option 2: Google Cloud Platform**
```yaml
# cloudbuild.yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/newslocal-backend', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/newslocal-backend']
  - name: 'gcr.io/cloud-builders/gcloud'
    args: ['run', 'deploy', 'newslocal-backend', '--image', 'gcr.io/$PROJECT_ID/newslocal-backend', '--platform', 'managed', '--region', 'us-central1']
```

#### **Option 3: DigitalOcean**
```yaml
# .do/app.yaml
name: newslocal-backend
services:
- name: api
  source_dir: /
  github:
    repo: your-username/newslocal
    branch: main
  run_command: npm start
  environment_slug: node-js
  instance_count: 1
  instance_size_slug: basic-xxs
  envs:
  - key: NODE_ENV
    value: production
```

### **Docker Configuration**

#### **Dockerfile**
```dockerfile
# Multi-stage build
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine AS runtime

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs

EXPOSE 3000
CMD ["npm", "start"]
```

#### **Docker Compose for Development**
```yaml
version: '3.8'
services:
  backend:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    depends_on:
      - redis
      - postgres

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  postgres:
    image: postgres:15
    environment:
      - POSTGRES_DB=newslocal_dev
      - POSTGRES_USER=developer
      - POSTGRES_PASSWORD=password
    ports:
      - "5432:5432"
    volumes:
      - postgres_dev_data:/var/lib/postgresql/data

volumes:
  postgres_dev_data:
```

### **Environment Configuration**

#### **Production Environment Variables**
```bash
# .env.production
NODE_ENV=production
PORT=3000

# Database
DATABASE_URL=postgresql://user:password@host:5432/newslocal
REDIS_URL=redis://redis-host:6379

# External APIs
NEWS_API_KEY=your_news_api_key
SENTRY_DSN=your_sentry_dsn

# Authentication
JWT_SECRET=your_super_secret_jwt_key
JWT_EXPIRES_IN=7d
JWT_REFRESH_EXPIRES_IN=30d

# Security
BCRYPT_ROUNDS=12
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Monitoring
LOG_LEVEL=info
ENABLE_METRICS=true
```

#### **Staging Environment Variables**
```bash
# .env.staging
NODE_ENV=staging
PORT=3000

# Database
DATABASE_URL=postgresql://staging_user:password@staging_host:5432/newslocal_staging
REDIS_URL=redis://staging_redis:6379

# External APIs
NEWS_API_KEY=staging_news_api_key
SENTRY_DSN=staging_sentry_dsn

# Authentication
JWT_SECRET=staging_jwt_secret
JWT_EXPIRES_IN=24h
JWT_REFRESH_EXPIRES_IN=7d

# Security
BCRYPT_ROUNDS=10
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX_REQUESTS=200

# Monitoring
LOG_LEVEL=debug
ENABLE_METRICS=true
```

## 🔄 CI/CD Pipeline

### **GitHub Actions Workflow**

#### **iOS Build & Test**
```yaml
# .github/workflows/ios.yml
name: iOS Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode
      run: sudo xcode-select -s /Applications/Xcode_15.0.app
    
    - name: Cache Swift Package Manager
      uses: actions/cache@v3
      with:
        path: .build
        key: ${{ runner.os }}-spm-${{ hashFiles('**/Package.resolved') }}
    
    - name: Build
      run: xcodebuild -scheme NewsLocal -destination 'platform=iOS Simulator,name=iPhone 15 Pro' clean build
    
    - name: Test
      run: xcodebuild -scheme NewsLocal -destination 'platform=iOS Simulator,name=iPhone 15 Pro' test
```

#### **Backend Build & Deploy**
```yaml
# .github/workflows/backend.yml
name: Backend Build and Deploy

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: password
          POSTGRES_DB: newslocal_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
        cache-dependency-path: backend/package-lock.json
    
    - name: Install dependencies
      run: |
        cd backend
        npm ci
    
    - name: Run tests
      run: |
        cd backend
        npm test
      env:
        DATABASE_URL: postgresql://postgres:password@localhost:5432/newslocal_test
        REDIS_URL: redis://localhost:6379
        NODE_ENV: test
    
    - name: Build Docker image
      run: |
        cd backend
        docker build -t newslocal-backend .
    
    - name: Deploy to staging
      if: github.ref == 'refs/heads/develop'
      run: |
        echo "Deploying to staging..."
        # Add your staging deployment commands here
    
    - name: Deploy to production
      if: github.ref == 'refs/heads/main'
      run: |
        echo "Deploying to production..."
        # Add your production deployment commands here
```

### **Automated Testing**

#### **Test Stages**
1. **Unit Tests**: Fast, isolated tests
2. **Integration Tests**: API and database tests
3. **End-to-End Tests**: Full user workflows
4. **Performance Tests**: Load and stress testing

#### **Quality Gates**
- **Code Coverage**: Minimum 80%
- **Performance**: Response time < 200ms
- **Security**: No critical vulnerabilities
- **Dependencies**: No known vulnerabilities

## 📊 Monitoring & Observability

### **Application Monitoring**

#### **Metrics Collection**
```typescript
// metrics.ts
import { register, Counter, Histogram } from 'prom-client';

const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

const activeConnections = new Counter({
  name: 'websocket_connections_active',
  help: 'Number of active WebSocket connections'
});

register.registerMetric(httpRequestDuration);
register.registerMetric(httpRequestTotal);
register.registerMetric(activeConnections);
```

#### **Health Checks**
```typescript
// health.ts
import { Request, Response } from 'express';
import { checkDatabase, checkRedis, checkExternalAPI } from './services';

export const healthCheck = async (req: Request, res: Response) => {
  const health = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version,
    uptime: process.uptime(),
    checks: {
      database: await checkDatabase(),
      redis: await checkRedis(),
      externalAPI: await checkExternalAPI()
    }
  };

  const isHealthy = Object.values(health.checks).every(check => check.status === 'ok');
  res.status(isHealthy ? 200 : 503).json(health);
};
```

### **Error Tracking**

#### **Sentry Integration**
```typescript
// sentry.ts
import * as Sentry from '@sentry/node';
import { ProfilingIntegration } from '@sentry/profiling-node';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  integrations: [
    new ProfilingIntegration(),
  ],
  tracesSampleRate: 1.0,
  profilesSampleRate: 1.0,
});

export default Sentry;
```

### **Logging Strategy**

#### **Structured Logging**
```typescript
// logger.ts
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'newslocal-backend' },
  transports: [
    new winston.transports.File({ filename: 'logs/error.log', level: 'error' }),
    new winston.transports.File({ filename: 'logs/combined.log' }),
  ],
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}

export default logger;
```

## 🔒 Security Deployment

### **SSL/TLS Configuration**

#### **Nginx Configuration**
```nginx
server {
    listen 443 ssl http2;
    server_name api.newslocal.com;
    
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
    ssl_prefer_server_ciphers off;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### **Firewall Configuration**
```bash
# UFW (Ubuntu)
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable

# iptables
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -j DROP
```

## 📈 Performance Optimization

### **Caching Strategy**

#### **Redis Configuration**
```conf
# redis.conf
maxmemory 256mb
maxmemory-policy allkeys-lru
save 900 1
save 300 10
save 60 10000
```

#### **CDN Configuration**
```typescript
// cdn.ts
const cdnConfig = {
  staticAssets: 'https://cdn.newslocal.com',
  images: 'https://images.newslocal.com',
  api: 'https://api.newslocal.com'
};
```

### **Database Optimization**

#### **Connection Pooling**
```typescript
// database.ts
import { Sequelize } from 'sequelize';

const sequelize = new Sequelize(databaseUrl, {
  dialect: 'postgres',
  pool: {
    max: 20,
    min: 0,
    acquire: 30000,
    idle: 10000
  },
  logging: false
});
```

## 🚀 Deployment Checklist

### **Pre-Deployment**
- [ ] All tests passing
- [ ] Security scan completed
- [ ] Performance benchmarks met
- [ ] Documentation updated
- [ ] Backup strategy in place
- [ ] Rollback plan prepared

### **Deployment**
- [ ] Environment variables configured
- [ ] Database migrations run
- [ ] SSL certificates valid
- [ ] Monitoring configured
- [ ] Health checks passing
- [ ] Load balancer configured

### **Post-Deployment**
- [ ] Smoke tests completed
- [ ] Performance monitoring active
- [ ] Error tracking configured
- [ ] User acceptance testing
- [ ] Documentation updated
- [ ] Team notified

---

**NewsLocal Deployment Guide** - Ready for production! 🚀📰

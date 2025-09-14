# NewsLocal Deployment Guide

This guide covers the complete deployment process for the NewsLocal application, including both the iOS app and backend API.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Backend Deployment](#backend-deployment)
3. [iOS App Deployment](#ios-app-deployment)
4. [Production Configuration](#production-configuration)
5. [Monitoring & Logging](#monitoring--logging)
6. [Security Considerations](#security-considerations)
7. [Backup & Recovery](#backup--recovery)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements
- Docker and Docker Compose
- Node.js 18+ (for local development)
- Xcode 15+ (for iOS development)
- macOS 14+ (for iOS development)

### External Services
- News API key (from newsapi.org)
- Domain name and SSL certificates
- Cloud provider account (AWS, GCP, or Azure)

## Backend Deployment

### 1. Development Environment

```bash
# Clone the repository
git clone https://github.com/your-org/newslocal.git
cd newslocal/backend

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env

# Update .env with your configuration
# Start the development server
npm run dev

# Seed the database
npm run seed
```

### 2. Production Deployment

#### Using Docker Compose (Recommended)

```bash
# Set up environment variables
cp .env.example .env.production

# Update production environment variables
# Start production services
docker-compose -f docker-compose.prod.yml up -d

# Check service status
docker-compose -f docker-compose.prod.yml ps
```

#### Manual Deployment

```bash
# Build the application
npm run build

# Start production server
npm start
```

### 3. Environment Variables

Required environment variables for production:

```bash
# Server Configuration
NODE_ENV=production
PORT=3000

# Database
DB_HOST=your-db-host
DB_NAME=newslocal_prod
DB_USER=your-db-user
DB_PASSWORD=your-secure-password

# Security
JWT_SECRET=your-super-secure-jwt-secret
REDIS_PASSWORD=your-redis-password

# External APIs
NEWS_API_KEY=your-news-api-key

# Monitoring
GRAFANA_PASSWORD=your-grafana-password
```

## iOS App Deployment

### 1. Development Setup

```bash
# Open the project in Xcode
open NewsLocal.xcodeproj

# Update API endpoint in Constants.swift
# Build and run on simulator
```

### 2. Production Build

```bash
# Build for release
xcodebuild -scheme NewsLocal \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  archive -archivePath NewsLocal.xcarchive

# Export for App Store
xcodebuild -exportArchive \
  -archivePath NewsLocal.xcarchive \
  -exportPath ./build \
  -exportOptionsPlist ExportOptions.plist
```

### 3. App Store Submission

1. Upload to App Store Connect
2. Configure app metadata
3. Submit for review
4. Release to App Store

## Production Configuration

### 1. SSL/TLS Setup

```bash
# Generate SSL certificates
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# Update nginx configuration
# Restart nginx
docker-compose restart nginx
```

### 2. Domain Configuration

```bash
# Update DNS records
# Point domain to your server IP
# Configure subdomains for API
```

### 3. Load Balancing

For high-traffic deployments, consider:

- Multiple backend instances
- Load balancer (nginx, HAProxy)
- Database replication
- Redis clustering

## Monitoring & Logging

### 1. Start Monitoring Stack

```bash
# Start monitoring services
docker-compose -f docker-compose.monitoring.yml up -d

# Access services
# Grafana: http://your-domain:3001
# Prometheus: http://your-domain:9090
# Kibana: http://your-domain:5601
```

### 2. Key Metrics to Monitor

- API response times
- Error rates
- Database performance
- Memory and CPU usage
- Disk space
- Network traffic

### 3. Log Management

- Application logs via ELK stack
- Container logs via Docker
- System logs via journald

## Security Considerations

### 1. Network Security

- Firewall configuration
- VPN access for admin
- DDoS protection
- Rate limiting

### 2. Application Security

- Input validation
- SQL injection prevention
- XSS protection
- CSRF tokens
- Secure headers

### 3. Data Protection

- Database encryption
- Backup encryption
- PII handling
- GDPR compliance

## Backup & Recovery

### 1. Database Backups

```bash
# Automated daily backups
docker-compose exec backup /backup-script.sh

# Manual backup
pg_dump -h postgres -U newslocal_user newslocal_prod > backup.sql
```

### 2. Application Backups

```bash
# Backup application code
tar -czf newslocal-backup-$(date +%Y%m%d).tar.gz .

# Backup configuration
cp -r config/ backups/
```

### 3. Recovery Procedures

```bash
# Restore database
psql -h postgres -U newslocal_user newslocal_prod < backup.sql

# Restore application
tar -xzf newslocal-backup-YYYYMMDD.tar.gz
```

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Check database credentials
   - Verify network connectivity
   - Check database service status

2. **API Not Responding**
   - Check application logs
   - Verify port configuration
   - Check resource usage

3. **iOS App Not Loading Data**
   - Verify API endpoint configuration
   - Check network connectivity
   - Review API response format

### Log Locations

- Application logs: `/var/log/newslocal/`
- Docker logs: `docker logs <container-name>`
- System logs: `/var/log/syslog`

### Performance Optimization

1. **Database Optimization**
   - Add indexes for frequently queried fields
   - Optimize queries
   - Configure connection pooling

2. **Caching**
   - Implement Redis caching
   - Use CDN for static assets
   - Enable browser caching

3. **Monitoring**
   - Set up alerts for critical metrics
   - Monitor error rates
   - Track performance trends

## Support

For deployment issues:

1. Check the logs first
2. Review this documentation
3. Contact the development team
4. Create an issue in the repository

## Updates

To update the application:

```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker-compose down
docker-compose up -d --build

# Verify deployment
curl http://your-domain/health
```

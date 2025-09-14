# NewsLocal API Documentation 📚

## Overview

NewsLocal API provides a comprehensive RESTful interface for news aggregation, user management, and real-time features. Built with Node.js, Express.js, and TypeScript, it offers high-performance, scalable, and secure access to news content and user data.

## Base Information

- **Base URL**: `https://api.newslocal.com/v1`
- **API Version**: v1
- **Protocol**: HTTPS
- **Data Format**: JSON
- **Authentication**: Bearer Token (JWT)

## Quick Start

### Authentication

```bash
# Register a new user
curl -X POST https://api.newslocal.com/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securePassword123",
    "name": "John Doe"
  }'

# Login
curl -X POST https://api.newslocal.com/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securePassword123"
  }'
```

### Get News Headlines

```bash
curl -X GET "https://api.newslocal.com/v1/news?page=1&limit=20" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Search Articles

```bash
curl -X GET "https://api.newslocal.com/v1/search?query=artificial%20intelligence&page=1&limit=10" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Authentication

### JWT Token Structure

```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "userId": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "iat": 1640995200,
    "exp": 1641600000
  }
}
```

### Token Usage

Include the JWT token in the Authorization header:

```bash
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Token Refresh

```bash
curl -X POST https://api.newslocal.com/v1/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "your_refresh_token"
  }'
```

## Endpoints

### Authentication Endpoints

#### Register User
```http
POST /auth/register
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "name": "John Doe"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "email": "user@example.com",
      "name": "John Doe",
      "preferences": {}
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### Login User
```http
POST /auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "email": "user@example.com",
      "name": "John Doe",
      "preferences": {
        "categories": ["technology", "science"],
        "darkMode": false,
        "notifications": true
      }
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### Logout User
```http
POST /auth/logout
```

**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Logged out successfully"
  }
}
```

### News Endpoints

#### Get Top Headlines
```http
GET /news
```

**Query Parameters:**
- `page` (integer, optional): Page number (default: 1)
- `limit` (integer, optional): Items per page (default: 20, max: 100)
- `category` (string, optional): Filter by category

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "article-123",
      "title": "Breaking: Major Technology Breakthrough",
      "content": "Full article content...",
      "summary": "Brief summary of the article",
      "author": "Jane Smith",
      "source": "TechNews",
      "publishedAt": "2023-12-01T10:00:00Z",
      "category": "technology",
      "imageUrl": "https://example.com/image.jpg",
      "articleUrl": "https://technews.com/article",
      "isBreaking": true,
      "isTrending": false,
      "viewCount": 1500,
      "likeCount": 50,
      "shareCount": 25,
      "readingTime": 5
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

#### Get Breaking News
```http
GET /news/breaking
```

**Query Parameters:**
- `limit` (integer, optional): Number of breaking news items (default: 10, max: 50)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "article-124",
      "title": "Emergency Alert: Major Event",
      "content": "Emergency content...",
      "summary": "Emergency summary",
      "author": "Emergency Reporter",
      "source": "Emergency News",
      "publishedAt": "2023-12-01T11:30:00Z",
      "category": "general",
      "imageUrl": "https://example.com/emergency.jpg",
      "articleUrl": "https://emergency.com/article",
      "isBreaking": true,
      "isTrending": true,
      "viewCount": 5000,
      "likeCount": 200,
      "shareCount": 100,
      "readingTime": 3
    }
  ]
}
```

#### Get Trending News
```http
GET /news/trending
```

**Query Parameters:**
- `limit` (integer, optional): Number of trending items (default: 10, max: 50)
- `timeframe` (string, optional): Time frame for trending analysis (1h, 6h, 24h, 7d, default: 24h)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "article-125",
      "title": "Viral Story: Amazing Discovery",
      "content": "Viral content...",
      "summary": "Viral summary",
      "author": "Viral Reporter",
      "source": "Viral News",
      "publishedAt": "2023-12-01T09:00:00Z",
      "category": "science",
      "imageUrl": "https://example.com/viral.jpg",
      "articleUrl": "https://viral.com/article",
      "isBreaking": false,
      "isTrending": true,
      "viewCount": 10000,
      "likeCount": 500,
      "shareCount": 300,
      "readingTime": 4
    }
  ]
}
```

#### Get Article by ID
```http
GET /news/{id}
```

**Path Parameters:**
- `id` (string, required): Article ID

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "article-123",
    "title": "Breaking: Major Technology Breakthrough",
    "content": "Full article content with detailed information...",
    "summary": "Brief summary of the article",
    "author": "Jane Smith",
    "source": "TechNews",
    "publishedAt": "2023-12-01T10:00:00Z",
    "category": "technology",
    "imageUrl": "https://example.com/image.jpg",
    "articleUrl": "https://technews.com/article",
    "isBreaking": true,
    "isTrending": false,
    "viewCount": 1500,
    "likeCount": 50,
    "shareCount": 25,
    "readingTime": 5,
    "relatedArticles": [
      {
        "id": "article-126",
        "title": "Related Technology News",
        "summary": "Related article summary"
      }
    ]
  }
}
```

### Category Endpoints

#### Get All Categories
```http
GET /categories
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "technology",
      "name": "technology",
      "displayName": "Technology",
      "icon": "laptop",
      "articleCount": 150
    },
    {
      "id": "science",
      "name": "science",
      "displayName": "Science",
      "icon": "flask",
      "articleCount": 75
    },
    {
      "id": "business",
      "name": "business",
      "displayName": "Business",
      "icon": "briefcase",
      "articleCount": 120
    }
  ]
}
```

#### Get Articles by Category
```http
GET /categories/{category}/articles
```

**Path Parameters:**
- `category` (string, required): Category ID

**Query Parameters:**
- `page` (integer, optional): Page number (default: 1)
- `limit` (integer, optional): Items per page (default: 20, max: 100)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "article-127",
      "title": "Latest Technology News",
      "summary": "Technology article summary",
      "author": "Tech Reporter",
      "source": "TechNews",
      "publishedAt": "2023-12-01T08:00:00Z",
      "category": "technology",
      "imageUrl": "https://example.com/tech.jpg",
      "articleUrl": "https://technews.com/latest",
      "isBreaking": false,
      "isTrending": false,
      "viewCount": 800,
      "likeCount": 30,
      "shareCount": 15,
      "readingTime": 6
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

### Search Endpoints

#### Search Articles
```http
GET /search
```

**Query Parameters:**
- `query` (string, required): Search query
- `page` (integer, optional): Page number (default: 1)
- `limit` (integer, optional): Items per page (default: 20, max: 100)
- `categories` (string, optional): Comma-separated category filters
- `sources` (string, optional): Comma-separated source filters
- `dateFrom` (string, optional): Start date filter (ISO 8601)
- `dateTo` (string, optional): End date filter (ISO 8601)
- `sortBy` (string, optional): Sort criteria (publishedAt, viewCount, likeCount, relevance, default: relevance)
- `sortOrder` (string, optional): Sort order (asc, desc, default: desc)

**Example:**
```bash
curl -X GET "https://api.newslocal.com/v1/search?query=artificial%20intelligence&categories=technology,science&sortBy=publishedAt&sortOrder=desc&page=1&limit=10" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "article-128",
      "title": "AI Breakthrough in Machine Learning",
      "summary": "Artificial intelligence makes significant progress...",
      "author": "AI Reporter",
      "source": "AI News",
      "publishedAt": "2023-12-01T07:00:00Z",
      "category": "technology",
      "imageUrl": "https://example.com/ai.jpg",
      "articleUrl": "https://ainews.com/breakthrough",
      "isBreaking": false,
      "isTrending": true,
      "viewCount": 2000,
      "likeCount": 100,
      "shareCount": 50,
      "readingTime": 8,
      "relevanceScore": 0.95
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 45,
    "totalPages": 5
  },
  "searchMetadata": {
    "query": "artificial intelligence",
    "filters": {
      "categories": ["technology", "science"],
      "sources": [],
      "dateRange": null
    },
    "executionTime": 0.125
  }
}
```

#### Get Search Suggestions
```http
GET /search/suggestions
```

**Query Parameters:**
- `query` (string, required): Partial search query (minimum 2 characters)

**Response:**
```json
{
  "success": true,
  "data": {
    "suggestions": [
      "artificial intelligence",
      "artificial intelligence news",
      "artificial intelligence breakthrough",
      "artificial intelligence ethics",
      "artificial intelligence jobs"
    ],
    "popularSearches": [
      "climate change",
      "cryptocurrency",
      "space exploration",
      "renewable energy",
      "quantum computing"
    ]
  }
}
```

#### Get Trending Searches
```http
GET /search/trending
```

**Response:**
```json
{
  "success": true,
  "data": {
    "trending": [
      {
        "query": "artificial intelligence",
        "count": 1250,
        "growth": 15.5
      },
      {
        "query": "climate change",
        "count": 980,
        "growth": 8.2
      },
      {
        "query": "cryptocurrency",
        "count": 850,
        "growth": -5.1
      }
    ],
    "categories": [
      {
        "category": "technology",
        "trendingQueries": ["AI", "blockchain", "quantum computing"]
      },
      {
        "category": "science",
        "trendingQueries": ["climate change", "space exploration", "renewable energy"]
      }
    ]
  }
}
```

### User Management Endpoints

#### Get User Profile
```http
GET /auth/me
```

**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "name": "John Doe",
    "preferences": {
      "categories": ["technology", "science", "business"],
      "sources": ["TechNews", "ScienceDaily", "BusinessWeek"],
      "darkMode": false,
      "notifications": true,
      "pushNotifications": true,
      "emailNotifications": false
    },
    "statistics": {
      "articlesRead": 150,
      "articlesLiked": 45,
      "articlesShared": 12,
      "searchQueries": 89,
      "joinedAt": "2023-11-01T00:00:00Z"
    }
  }
}
```

#### Update User Profile
```http
PUT /auth/me
```

**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "John Smith",
  "preferences": {
    "categories": ["technology", "science"],
    "sources": ["TechNews", "ScienceDaily"],
    "darkMode": true,
    "notifications": true
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "email": "user@example.com",
    "name": "John Smith",
    "preferences": {
      "categories": ["technology", "science"],
      "sources": ["TechNews", "ScienceDaily"],
      "darkMode": true,
      "notifications": true,
      "pushNotifications": true,
      "emailNotifications": false
    }
  }
}
```

#### Change Password
```http
POST /auth/change-password
```

**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
```

**Request Body:**
```json
{
  "currentPassword": "oldPassword123",
  "newPassword": "newSecurePassword456"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": "Password changed successfully"
  }
}
```

### Real-time Endpoints

#### Get Real-time Statistics
```http
GET /realtime/stats
```

**Headers:**
```
Authorization: Bearer YOUR_JWT_TOKEN
```

**Response:**
```json
{
  "success": true,
  "data": {
    "connectedUsers": 1250,
    "activeSessions": 890,
    "lastUpdate": "2023-12-01T12:00:00Z",
    "systemStatus": {
      "database": "healthy",
      "redis": "healthy",
      "externalAPI": "healthy"
    },
    "metrics": {
      "requestsPerSecond": 45.2,
      "averageResponseTime": 125,
      "errorRate": 0.02
    }
  }
}
```

#### Get Live Search Suggestions
```http
GET /realtime/suggestions
```

**Query Parameters:**
- `query` (string, required): Partial search query

**Response:**
```json
{
  "success": true,
  "data": [
    "artificial intelligence",
    "artificial intelligence news",
    "artificial intelligence breakthrough"
  ]
}
```

## WebSocket Events

### Connection

```javascript
const socket = io('https://api.newslocal.com', {
  auth: {
    token: 'your_jwt_token'
  }
});
```

### Client Events

#### Subscribe to Breaking News
```javascript
socket.emit('subscribe_breaking_news');
```

#### Subscribe to Category Updates
```javascript
socket.emit('subscribe_category', { category: 'technology' });
```

#### Track Article View
```javascript
socket.emit('article_view', { 
  articleId: 'article-123',
  timestamp: new Date().toISOString()
});
```

#### Track Article Like
```javascript
socket.emit('article_like', { 
  articleId: 'article-123',
  timestamp: new Date().toISOString()
});
```

#### Track Article Share
```javascript
socket.emit('article_share', { 
  articleId: 'article-123',
  platform: 'twitter',
  timestamp: new Date().toISOString()
});
```

### Server Events

#### Breaking News Notification
```javascript
socket.on('breaking_news', (data) => {
  console.log('Breaking news:', data);
  // data contains the breaking news article
});
```

#### Category News Update
```javascript
socket.on('category_news', (data) => {
  console.log('Category news:', data);
  // data contains new articles for subscribed category
});
```

#### System Notification
```javascript
socket.on('notification', (data) => {
  console.log('System notification:', data);
  // data contains system notification
});
```

#### Trending Topics Update
```javascript
socket.on('trending_topics', (data) => {
  console.log('Trending topics:', data);
  // data contains trending topics
});
```

#### Search Suggestions
```javascript
socket.on('search_suggestions', (data) => {
  console.log('Live suggestions:', data);
  // data contains real-time search suggestions
});
```

## Error Handling

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request parameters",
    "details": {
      "field": "email",
      "reason": "Invalid email format"
    },
    "timestamp": "2023-12-01T12:00:00Z",
    "requestId": "req-123456789"
  }
}
```

### Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Request validation failed |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | Access denied |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Resource already exists |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Internal server error |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |

### Common Errors

#### Authentication Error
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or expired token",
    "timestamp": "2023-12-01T12:00:00Z"
  }
}
```

#### Validation Error
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "reason": "Invalid email format"
      },
      {
        "field": "password",
        "reason": "Password must be at least 8 characters"
      }
    ],
    "timestamp": "2023-12-01T12:00:00Z"
  }
}
```

#### Rate Limit Error
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again later.",
    "details": {
      "limit": 100,
      "remaining": 0,
      "resetTime": "2023-12-01T12:05:00Z"
    },
    "timestamp": "2023-12-01T12:00:00Z"
  }
}
```

## Rate Limiting

### Rate Limits

| Endpoint Category | Limit | Window |
|-------------------|-------|---------|
| Authentication | 5 requests | 15 minutes |
| News (authenticated) | 100 requests | 1 minute |
| News (anonymous) | 60 requests | 1 minute |
| Search | 60 requests | 1 minute |
| User Management | 30 requests | 1 minute |
| Real-time | 20 requests | 1 minute |

### Rate Limit Headers

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995260
```

## SDKs and Libraries

### JavaScript/Node.js

```javascript
import NewsLocalAPI from '@newslocal/api-client';

const api = new NewsLocalAPI({
  baseURL: 'https://api.newslocal.com/v1',
  apiKey: 'your_api_key'
});

// Get top headlines
const headlines = await api.news.getTopHeadlines({
  page: 1,
  limit: 20,
  category: 'technology'
});

// Search articles
const results = await api.search.searchArticles({
  query: 'artificial intelligence',
  filters: {
    categories: ['technology', 'science'],
    dateFrom: '2023-12-01',
    dateTo: '2023-12-31'
  }
});
```

### Python

```python
from newslocal import NewsLocalAPI

api = NewsLocalAPI(
    base_url='https://api.newslocal.com/v1',
    api_key='your_api_key'
)

# Get top headlines
headlines = api.news.get_top_headlines(
    page=1,
    limit=20,
    category='technology'
)

# Search articles
results = api.search.search_articles(
    query='artificial intelligence',
    filters={
        'categories': ['technology', 'science'],
        'date_from': '2023-12-01',
        'date_to': '2023-12-31'
    }
)
```

### Swift

```swift
import NewsLocalAPI

let api = NewsLocalAPI(baseURL: "https://api.newslocal.com/v1")

// Get top headlines
let headlines = try await api.news.getTopHeadlines(
    page: 1,
    limit: 20,
    category: "technology"
)

// Search articles
let results = try await api.search.searchArticles(
    query: "artificial intelligence",
    filters: SearchFilters(
        categories: ["technology", "science"],
        dateFrom: Date(),
        dateTo: Calendar.current.date(byAdding: .month, value: 1, to: Date())
    )
)
```

## Testing

### Postman Collection

Import the NewsLocal API Postman collection for easy testing:

[Download Postman Collection](./postman/NewsLocal-API.postman_collection.json)

### Interactive Documentation

Visit the interactive API documentation at:
- **Swagger UI**: `https://api.newslocal.com/docs`
- **ReDoc**: `https://api.newslocal.com/redoc`

### Test Environment

For testing purposes, use the staging environment:
- **Base URL**: `https://staging-api.newslocal.com/v1`
- **API Key**: Contact support for test credentials

## Support

### Getting Help

- **Documentation**: This API documentation
- **Interactive Docs**: Swagger UI at `/docs`
- **Support Email**: api-support@newslocal.com
- **GitHub Issues**: [Repository Issues](https://github.com/newslocal/api/issues)
- **Status Page**: [API Status](https://status.newslocal.com)

### Response Times

- **P50**: < 100ms
- **P95**: < 300ms
- **P99**: < 500ms

### Service Level Agreement (SLA)

- **Uptime**: 99.9% availability
- **Response Time**: 95% of requests < 200ms
- **Support**: 24/7 for critical issues

---

**NewsLocal API Documentation** - Powerful, reliable, and easy to use! 📚🚀

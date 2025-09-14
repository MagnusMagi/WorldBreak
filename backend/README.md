# NewsLocal Backend API

Backend API for the NewsLocal iOS application built with Node.js, Express.js, and TypeScript.

## Features

- RESTful API for news management
- SQLite database with Sequelize ORM
- JWT authentication (placeholder)
- Rate limiting and security middleware
- Comprehensive error handling
- Mock data seeding
- TypeScript support

## Getting Started

### Prerequisites

- Node.js 18.0.0 or higher
- npm or yarn

### Installation

1. Install dependencies:
```bash
npm install
```

2. Copy environment variables:
```bash
cp .env.example .env
```

3. Update `.env` file with your configuration

4. Seed the database with mock data:
```bash
npm run seed
```

5. Start the development server:
```bash
npm run dev
```

## API Endpoints

### News
- `GET /api/v1/news/headlines` - Get top headlines
- `GET /api/v1/news/category?category=technology` - Get news by category
- `GET /api/v1/news/search?q=query` - Search news
- `GET /api/v1/news/breaking` - Get breaking news
- `GET /api/v1/news/trending` - Get trending news
- `GET /api/v1/news/recommended` - Get recommended news
- `GET /api/v1/news/detail/:id` - Get article detail
- `POST /api/v1/news/:id/like` - Like an article
- `POST /api/v1/news/:id/share` - Share an article

### User (Placeholder)
- `GET /api/v1/user/preferences` - Get user preferences
- `PUT /api/v1/user/preferences` - Update user preferences
- `GET /api/v1/user/history` - Get reading history

### Authentication (Placeholder)
- `POST /api/v1/auth/register` - Register user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/logout` - Logout user
- `POST /api/v1/auth/refresh` - Refresh token

## Scripts

- `npm start` - Start production server
- `npm run dev` - Start development server with hot reload
- `npm run build` - Build TypeScript to JavaScript
- `npm test` - Run tests
- `npm run lint` - Run ESLint
- `npm run seed` - Seed database with mock data

## Database

The application uses SQLite for development. The database file will be created automatically as `database.sqlite` in the backend directory.

## Architecture

- **Controllers**: Handle HTTP requests and responses
- **Services**: Business logic and data processing
- **Models**: Database models using Sequelize ORM
- **Routes**: API route definitions
- **Middleware**: Request processing middleware
- **Utils**: Utility functions and helpers

## Security

- Helmet.js for security headers
- CORS configuration
- Rate limiting
- Input validation
- Error handling

## Development

The project follows TypeScript best practices with:
- Strict type checking
- ESLint configuration
- Jest testing framework
- Comprehensive error handling
- Modular architecture

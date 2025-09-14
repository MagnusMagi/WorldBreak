import request from 'supertest';
import app from '../server';
import { sequelize } from '../config/database';
import { Article } from '../models/Article';

describe('News Controller', () => {
  beforeAll(async () => {
    await sequelize.sync({ force: true });
    
    // Create test articles
    await Article.bulkCreate([
      {
        title: 'Test Article 1',
        content: 'This is test content for article 1',
        summary: 'Test summary 1',
        author: 'Test Author 1',
        publishedAt: new Date(),
        category: 'technology',
        sourceId: 'source_1',
        sourceName: 'Test Source 1',
        isBreaking: false,
        readTime: 3,
        tags: ['test', 'technology'],
        shareCount: 10,
        likeCount: 20
      },
      {
        title: 'Breaking News Test',
        content: 'This is breaking news content',
        summary: 'Breaking news summary',
        author: 'Breaking Author',
        publishedAt: new Date(),
        category: 'politics',
        sourceId: 'source_2',
        sourceName: 'Breaking Source',
        isBreaking: true,
        readTime: 2,
        tags: ['breaking', 'politics'],
        shareCount: 100,
        likeCount: 200
      }
    ]);
  });

  afterAll(async () => {
    await sequelize.close();
  });

  describe('GET /api/v1/news/headlines', () => {
    it('should return top headlines', async () => {
      const response = await request(app)
        .get('/api/v1/news/headlines')
        .expect(200);

      expect(response.body).toHaveProperty('articles');
      expect(response.body).toHaveProperty('totalResults');
      expect(response.body).toHaveProperty('page');
      expect(response.body).toHaveProperty('totalPages');
      expect(Array.isArray(response.body.articles)).toBe(true);
    });

    it('should handle pagination', async () => {
      const response = await request(app)
        .get('/api/v1/news/headlines?page=1&pageSize=1')
        .expect(200);

      expect(response.body.articles.length).toBeLessThanOrEqual(1);
      expect(response.body.page).toBe(1);
    });
  });

  describe('GET /api/v1/news/category', () => {
    it('should return news by category', async () => {
      const response = await request(app)
        .get('/api/v1/news/category?category=technology')
        .expect(200);

      expect(response.body).toHaveProperty('articles');
      expect(response.body.articles.every((article: any) => 
        article.category === 'technology')).toBe(true);
    });

    it('should return 400 for missing category', async () => {
      await request(app)
        .get('/api/v1/news/category')
        .expect(400);
    });
  });

  describe('GET /api/v1/news/search', () => {
    it('should search news by query', async () => {
      const response = await request(app)
        .get('/api/v1/news/search?q=test')
        .expect(200);

      expect(response.body).toHaveProperty('articles');
      expect(Array.isArray(response.body.articles)).toBe(true);
    });

    it('should return 400 for missing query', async () => {
      await request(app)
        .get('/api/v1/news/search')
        .expect(400);
    });
  });

  describe('GET /api/v1/news/breaking', () => {
    it('should return breaking news', async () => {
      const response = await request(app)
        .get('/api/v1/news/breaking')
        .expect(200);

      expect(response.body).toHaveProperty('articles');
      expect(response.body.articles.every((article: any) => 
        article.isBreaking === true)).toBe(true);
    });
  });

  describe('GET /api/v1/news/trending', () => {
    it('should return trending news', async () => {
      const response = await request(app)
        .get('/api/v1/news/trending')
        .expect(200);

      expect(response.body).toHaveProperty('articles');
      expect(Array.isArray(response.body.articles)).toBe(true);
    });
  });

  describe('GET /api/v1/news/detail/:id', () => {
    it('should return article detail', async () => {
      const articles = await Article.findAll();
      const articleId = articles[0].id;

      const response = await request(app)
        .get(`/api/v1/news/detail/${articleId}`)
        .expect(200);

      expect(response.body).toHaveProperty('id', articleId);
      expect(response.body).toHaveProperty('title');
      expect(response.body).toHaveProperty('content');
    });

    it('should return 404 for non-existent article', async () => {
      const fakeId = '00000000-0000-0000-0000-000000000000';
      
      await request(app)
        .get(`/api/v1/news/detail/${fakeId}`)
        .expect(404);
    });

    it('should return 400 for invalid UUID', async () => {
      await request(app)
        .get('/api/v1/news/detail/invalid-id')
        .expect(400);
    });
  });

  describe('POST /api/v1/news/:id/like', () => {
    it('should like an article', async () => {
      const articles = await Article.findAll();
      const articleId = articles[0].id;
      const originalLikeCount = articles[0].likeCount;

      const response = await request(app)
        .post(`/api/v1/news/${articleId}/like`)
        .expect(200);

      expect(response.body).toHaveProperty('likeCount');
      expect(response.body.likeCount).toBe(originalLikeCount + 1);
    });
  });

  describe('POST /api/v1/news/:id/share', () => {
    it('should share an article', async () => {
      const articles = await Article.findAll();
      const articleId = articles[0].id;
      const originalShareCount = articles[0].shareCount;

      const response = await request(app)
        .post(`/api/v1/news/${articleId}/share`)
        .expect(200);

      expect(response.body).toHaveProperty('shareCount');
      expect(response.body.shareCount).toBe(originalShareCount + 1);
    });
  });
});

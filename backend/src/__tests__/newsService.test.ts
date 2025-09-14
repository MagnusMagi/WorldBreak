import { newsService } from '../services/newsService';
import { sequelize } from '../config/database';
import { Article } from '../models/Article';

describe('News Service', () => {
  beforeAll(async () => {
    await sequelize.sync({ force: true });
    
    // Create test articles
    await Article.bulkCreate([
      {
        title: 'Technology News',
        content: 'Technology content here',
        summary: 'Tech summary',
        author: 'Tech Author',
        publishedAt: new Date(Date.now() - 1000),
        category: 'technology',
        sourceId: 'tech_source',
        sourceName: 'Tech Source',
        isBreaking: false,
        readTime: 3,
        tags: ['technology'],
        shareCount: 50,
        likeCount: 100
      },
      {
        title: 'Breaking Politics',
        content: 'Politics content here',
        summary: 'Politics summary',
        author: 'Politics Author',
        publishedAt: new Date(Date.now() - 2000),
        category: 'politics',
        sourceId: 'politics_source',
        sourceName: 'Politics Source',
        isBreaking: true,
        readTime: 4,
        tags: ['politics'],
        shareCount: 200,
        likeCount: 300
      },
      {
        title: 'Sports News',
        content: 'Sports content here',
        summary: 'Sports summary',
        author: 'Sports Author',
        publishedAt: new Date(Date.now() - 3000),
        category: 'sports',
        sourceId: 'sports_source',
        sourceName: 'Sports Source',
        isBreaking: false,
        readTime: 2,
        tags: ['sports'],
        shareCount: 150,
        likeCount: 250
      }
    ]);
  });

  afterAll(async () => {
    await sequelize.close();
  });

  describe('getTopHeadlines', () => {
    it('should return paginated headlines', async () => {
      const result = await newsService.getTopHeadlines(1, 2);
      
      expect(result).toHaveProperty('articles');
      expect(result).toHaveProperty('totalResults');
      expect(result).toHaveProperty('page');
      expect(result).toHaveProperty('totalPages');
      expect(result.articles.length).toBeLessThanOrEqual(2);
      expect(result.page).toBe(1);
    });
  });

  describe('getNewsByCategory', () => {
    it('should return articles for specific category', async () => {
      const result = await newsService.getNewsByCategory('technology', 1, 10);
      
      expect(result.articles.every(article => article.category === 'technology')).toBe(true);
      expect(result.totalResults).toBeGreaterThan(0);
    });

    it('should return empty results for non-existent category', async () => {
      const result = await newsService.getNewsByCategory('nonexistent', 1, 10);
      
      expect(result.articles.length).toBe(0);
      expect(result.totalResults).toBe(0);
    });
  });

  describe('searchNews', () => {
    it('should search articles by title', async () => {
      const result = await newsService.searchNews('Technology', 1, 10);
      
      expect(result.articles.some(article => 
        article.title.toLowerCase().includes('technology'))).toBe(true);
    });

    it('should search articles by content', async () => {
      const result = await newsService.searchNews('content', 1, 10);
      
      expect(result.articles.length).toBeGreaterThan(0);
    });

    it('should return empty results for non-existent query', async () => {
      const result = await newsService.searchNews('nonexistentquery', 1, 10);
      
      expect(result.articles.length).toBe(0);
      expect(result.totalResults).toBe(0);
    });
  });

  describe('getBreakingNews', () => {
    it('should return only breaking news articles', async () => {
      const result = await newsService.getBreakingNews();
      
      expect(result.every(article => article.isBreaking === true)).toBe(true);
      expect(result.length).toBeGreaterThan(0);
    });
  });

  describe('getTrendingNews', () => {
    it('should return trending articles ordered by engagement', async () => {
      const result = await newsService.getTrendingNews();
      
      expect(result.length).toBeGreaterThan(0);
      // Should be ordered by share count and like count
      for (let i = 1; i < result.length; i++) {
        const prev = result[i - 1];
        const curr = result[i];
        expect(prev.shareCount >= curr.shareCount || prev.likeCount >= curr.likeCount).toBe(true);
      }
    });
  });

  describe('getRecommendedNews', () => {
    it('should return recommended articles', async () => {
      const result = await newsService.getRecommendedNews();
      
      expect(result.length).toBeGreaterThan(0);
      expect(result.length).toBeLessThanOrEqual(15);
    });
  });

  describe('getArticleById', () => {
    it('should return article by ID', async () => {
      const articles = await Article.findAll();
      const articleId = articles[0].id;
      
      const result = await newsService.getArticleById(articleId);
      
      expect(result.id).toBe(articleId);
      expect(result).toHaveProperty('title');
      expect(result).toHaveProperty('content');
    });

    it('should throw error for non-existent article', async () => {
      const fakeId = '00000000-0000-0000-0000-000000000000';
      
      await expect(newsService.getArticleById(fakeId))
        .rejects.toThrow('Article not found');
    });
  });

  describe('likeArticle', () => {
    it('should increment like count', async () => {
      const articles = await Article.findAll();
      const article = articles[0];
      const originalLikeCount = article.likeCount;
      
      const result = await newsService.likeArticle(article.id);
      
      expect(result.likeCount).toBe(originalLikeCount + 1);
    });
  });

  describe('shareArticle', () => {
    it('should increment share count', async () => {
      const articles = await Article.findAll();
      const article = articles[0];
      const originalShareCount = article.shareCount;
      
      const result = await newsService.shareArticle(article.id);
      
      expect(result.shareCount).toBe(originalShareCount + 1);
    });
  });
});

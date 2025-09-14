import { Request, Response } from 'express';
import { newsService } from '../services/newsService';

export const newsController = {
  async getTopHeadlines(req: Request, res: Response) {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const pageSize = parseInt(req.query.pageSize as string) || 20;
      
      const result = await newsService.getTopHeadlines(page, pageSize);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch headlines' });
    }
  },

  async getNewsByCategory(req: Request, res: Response) {
    try {
      const { category } = req.query;
      const page = parseInt(req.query.page as string) || 1;
      const pageSize = parseInt(req.query.pageSize as string) || 20;
      
      const result = await newsService.getNewsByCategory(category as string, page, pageSize);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch news by category' });
    }
  },

  async searchNews(req: Request, res: Response) {
    try {
      const { q } = req.query;
      const page = parseInt(req.query.page as string) || 1;
      const pageSize = parseInt(req.query.pageSize as string) || 20;
      
      const result = await newsService.searchNews(q as string, page, pageSize);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: 'Failed to search news' });
    }
  },

  async getBreakingNews(req: Request, res: Response) {
    try {
      const result = await newsService.getBreakingNews();
      res.json({ articles: result });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch breaking news' });
    }
  },

  async getTrendingNews(req: Request, res: Response) {
    try {
      const result = await newsService.getTrendingNews();
      res.json({ articles: result });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch trending news' });
    }
  },

  async getRecommendedNews(req: Request, res: Response) {
    try {
      const result = await newsService.getRecommendedNews();
      res.json({ articles: result });
    } catch (error) {
      res.status(500).json({ error: 'Failed to fetch recommended news' });
    }
  },

  async getArticleDetail(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const result = await newsService.getArticleById(id);
      res.json(result);
    } catch (error) {
      res.status(404).json({ error: 'Article not found' });
    }
  },

  async likeArticle(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const result = await newsService.likeArticle(id);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: 'Failed to like article' });
    }
  },

  async shareArticle(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const result = await newsService.shareArticle(id);
      res.json(result);
    } catch (error) {
      res.status(500).json({ error: 'Failed to share article' });
    }
  }
};

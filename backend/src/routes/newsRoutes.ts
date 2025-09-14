import { Router } from 'express';
import { newsController } from '../controllers/newsController';
import { validateRequest } from '../middleware/validateRequest';
import { query, param } from 'express-validator';

const router = Router();

// Get top headlines
router.get('/headlines', [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('pageSize').optional().isInt({ min: 1, max: 50 }).withMessage('Page size must be between 1 and 50'),
  validateRequest
], newsController.getTopHeadlines);

// Get news by category
router.get('/category', [
  query('category').notEmpty().withMessage('Category is required'),
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('pageSize').optional().isInt({ min: 1, max: 50 }).withMessage('Page size must be between 1 and 50'),
  validateRequest
], newsController.getNewsByCategory);

// Search news
router.get('/search', [
  query('q').notEmpty().withMessage('Search query is required'),
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive integer'),
  query('pageSize').optional().isInt({ min: 1, max: 50 }).withMessage('Page size must be between 1 and 50'),
  validateRequest
], newsController.searchNews);

// Get breaking news
router.get('/breaking', newsController.getBreakingNews);

// Get trending news
router.get('/trending', newsController.getTrendingNews);

// Get recommended news
router.get('/recommended', newsController.getRecommendedNews);

// Get article detail
router.get('/detail/:id', [
  param('id').isUUID().withMessage('Invalid article ID'),
  validateRequest
], newsController.getArticleDetail);

// Like article
router.post('/:id/like', [
  param('id').isUUID().withMessage('Invalid article ID'),
  validateRequest
], newsController.likeArticle);

// Share article
router.post('/:id/share', [
  param('id').isUUID().withMessage('Invalid article ID'),
  validateRequest
], newsController.shareArticle);

export default router;

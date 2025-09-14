import { Article } from '../models/Article';
import { Op } from 'sequelize';

export const newsService = {
  async getTopHeadlines(page: number = 1, pageSize: number = 20) {
    const offset = (page - 1) * pageSize;
    
    const { count, rows } = await Article.findAndCountAll({
      order: [['publishedAt', 'DESC']],
      limit: pageSize,
      offset: offset
    });

    return {
      articles: rows,
      totalResults: count,
      page: page,
      totalPages: Math.ceil(count / pageSize)
    };
  },

  async getNewsByCategory(category: string, page: number = 1, pageSize: number = 20) {
    const offset = (page - 1) * pageSize;
    
    const { count, rows } = await Article.findAndCountAll({
      where: { category },
      order: [['publishedAt', 'DESC']],
      limit: pageSize,
      offset: offset
    });

    return {
      articles: rows,
      totalResults: count,
      page: page,
      totalPages: Math.ceil(count / pageSize)
    };
  },

  async searchNews(query: string, page: number = 1, pageSize: number = 20) {
    const offset = (page - 1) * pageSize;
    
    const { count, rows } = await Article.findAndCountAll({
      where: {
        [Op.or]: [
          { title: { [Op.iLike]: `%${query}%` } },
          { content: { [Op.iLike]: `%${query}%` } },
          { summary: { [Op.iLike]: `%${query}%` } },
          { tags: { [Op.contains]: [query] } }
        ]
      },
      order: [['publishedAt', 'DESC']],
      limit: pageSize,
      offset: offset
    });

    return {
      articles: rows,
      totalResults: count,
      page: page,
      totalPages: Math.ceil(count / pageSize)
    };
  },

  async getBreakingNews() {
    return await Article.findAll({
      where: { isBreaking: true },
      order: [['publishedAt', 'DESC']],
      limit: 10
    });
  },

  async getTrendingNews() {
    return await Article.findAll({
      order: [['shareCount', 'DESC'], ['likeCount', 'DESC']],
      limit: 10
    });
  },

  async getRecommendedNews() {
    // Simple recommendation based on recent articles with high engagement
    return await Article.findAll({
      where: {
        [Op.or]: [
          { shareCount: { [Op.gt]: 100 } },
          { likeCount: { [Op.gt]: 500 } }
        ]
      },
      order: [['publishedAt', 'DESC']],
      limit: 15
    });
  },

  async getArticleById(id: string) {
    const article = await Article.findByPk(id);
    if (!article) {
      throw new Error('Article not found');
    }
    return article;
  },

  async likeArticle(id: string) {
    const article = await Article.findByPk(id);
    if (!article) {
      throw new Error('Article not found');
    }
    
    await article.increment('likeCount');
    return { likeCount: article.likeCount + 1 };
  },

  async shareArticle(id: string) {
    const article = await Article.findByPk(id);
    if (!article) {
      throw new Error('Article not found');
    }
    
    await article.increment('shareCount');
    return { shareCount: article.shareCount + 1 };
  }
};

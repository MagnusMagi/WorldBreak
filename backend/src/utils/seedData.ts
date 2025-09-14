import { sequelize } from '../config/database';
import { Article } from '../models/Article';

const mockArticles = [
  {
    title: 'Breaking: Major Economic Policy Changes Announced',
    content: 'In a significant development that will impact millions of citizens, government officials today announced comprehensive economic reforms aimed at stimulating growth and reducing inequality. The new policies include tax adjustments, infrastructure investments, and support for small businesses. Experts predict these changes will create thousands of new jobs and improve the overall economic outlook for the coming year.',
    summary: 'Government officials announced comprehensive economic reforms aimed at stimulating growth and reducing inequality.',
    author: 'Sarah Johnson',
    publishedAt: new Date(Date.now() - 2 * 60 * 60 * 1000), // 2 hours ago
    category: 'politics',
    imageUrl: 'https://picsum.photos/800/600?random=1',
    sourceId: 'source_1',
    sourceName: 'Global Times',
    sourceLogoUrl: 'https://picsum.photos/100/100?random=1',
    isBreaking: true,
    readTime: 5,
    tags: ['Politics', 'Economy', 'Policy'],
    shareCount: 1250,
    likeCount: 3400
  },
  {
    title: 'Technology Giant Reports Record Quarterly Earnings',
    content: 'The technology sector continues to show remarkable resilience as leading companies report unprecedented growth in their latest quarterly earnings. This performance reflects the increasing digital transformation across industries and the growing demand for innovative solutions. Investors are optimistic about the sector\'s future prospects.',
    summary: 'Leading technology companies report unprecedented growth in quarterly earnings, reflecting digital transformation trends.',
    author: 'Michael Chen',
    publishedAt: new Date(Date.now() - 4 * 60 * 60 * 1000), // 4 hours ago
    category: 'technology',
    imageUrl: 'https://picsum.photos/800/600?random=2',
    sourceId: 'source_2',
    sourceName: 'TechNews Daily',
    sourceLogoUrl: 'https://picsum.photos/100/100?random=2',
    isBreaking: false,
    readTime: 3,
    tags: ['Technology', 'Business', 'Earnings'],
    shareCount: 890,
    likeCount: 2100
  },
  {
    title: 'Climate Summit Reaches Historic Agreement',
    content: 'After weeks of intensive negotiations, world leaders have reached a groundbreaking agreement on climate action. The new framework includes ambitious targets for carbon reduction, renewable energy adoption, and environmental protection measures. This agreement represents a historic moment in the global fight against climate change.',
    summary: 'World leaders reached a groundbreaking agreement on climate action with ambitious targets for carbon reduction.',
    author: 'Emily Rodriguez',
    publishedAt: new Date(Date.now() - 6 * 60 * 60 * 1000), // 6 hours ago
    category: 'world',
    imageUrl: 'https://picsum.photos/800/600?random=3',
    sourceId: 'source_3',
    sourceName: 'World Report',
    sourceLogoUrl: 'https://picsum.photos/100/100?random=3',
    isBreaking: true,
    readTime: 6,
    tags: ['Climate', 'Environment', 'Global'],
    shareCount: 2100,
    likeCount: 5600
  }
];

export const seedDatabase = async () => {
  try {
    await sequelize.sync({ force: true });
    
    await Article.bulkCreate(mockArticles);
    
    console.log('Database seeded successfully with mock data');
  } catch (error) {
    console.error('Error seeding database:', error);
  }
};

// Run seed if this file is executed directly
if (require.main === module) {
  seedDatabase().then(() => {
    process.exit(0);
  }).catch((error) => {
    console.error('Seed failed:', error);
    process.exit(1);
  });
}

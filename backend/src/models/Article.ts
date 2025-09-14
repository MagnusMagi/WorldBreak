import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

export interface ArticleAttributes {
  id: string;
  title: string;
  content: string;
  summary: string;
  author: string;
  publishedAt: Date;
  category: string;
  imageUrl?: string;
  sourceId: string;
  sourceName: string;
  sourceLogoUrl?: string;
  isBreaking: boolean;
  readTime: number;
  tags: string[];
  shareCount: number;
  likeCount: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface ArticleCreationAttributes extends Optional<ArticleAttributes, 'id' | 'createdAt' | 'updatedAt'> {}

export class Article extends Model<ArticleAttributes, ArticleCreationAttributes> implements ArticleAttributes {
  public id!: string;
  public title!: string;
  public content!: string;
  public summary!: string;
  public author!: string;
  public publishedAt!: Date;
  public category!: string;
  public imageUrl?: string;
  public sourceId!: string;
  public sourceName!: string;
  public sourceLogoUrl?: string;
  public isBreaking!: boolean;
  public readTime!: number;
  public tags!: string[];
  public shareCount!: number;
  public likeCount!: number;
  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

Article.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    title: {
      type: DataTypes.STRING(500),
      allowNull: false
    },
    content: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    summary: {
      type: DataTypes.TEXT,
      allowNull: false
    },
    author: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    publishedAt: {
      type: DataTypes.DATE,
      allowNull: false
    },
    category: {
      type: DataTypes.STRING(50),
      allowNull: false
    },
    imageUrl: {
      type: DataTypes.STRING(500),
      allowNull: true
    },
    sourceId: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    sourceName: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    sourceLogoUrl: {
      type: DataTypes.STRING(500),
      allowNull: true
    },
    isBreaking: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    readTime: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    tags: {
      type: DataTypes.JSON,
      allowNull: false,
      defaultValue: []
    },
    shareCount: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    },
    likeCount: {
      type: DataTypes.INTEGER,
      defaultValue: 0
    }
  },
  {
    sequelize,
    tableName: 'articles',
    timestamps: true,
    indexes: [
      {
        fields: ['category']
      },
      {
        fields: ['publishedAt']
      },
      {
        fields: ['isBreaking']
      },
      {
        fields: ['sourceId']
      }
    ]
  }
);

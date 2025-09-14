import { DataTypes, Model, Optional } from 'sequelize';
import { sequelize } from '../config/database';

export interface UserAttributes {
  id: string;
  email: string;
  password: string;
  firstName?: string;
  lastName?: string;
  preferredCategories: string[];
  preferredSources: string[];
  notificationSettings: {
    breakingNews: boolean;
    categoryUpdates: boolean;
    personalizedNews: boolean;
    pushNotifications: boolean;
  };
  readingPreferences: {
    fontSize: 'small' | 'medium' | 'large';
    darkMode: boolean;
    autoPlayVideos: boolean;
    showImages: boolean;
  };
  location?: string;
  isActive: boolean;
  lastLoginAt?: Date;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface UserCreationAttributes extends Optional<UserAttributes, 'id' | 'createdAt' | 'updatedAt'> {}

export class User extends Model<UserAttributes, UserCreationAttributes> implements UserAttributes {
  public id!: string;
  public email!: string;
  public password!: string;
  public firstName?: string;
  public lastName?: string;
  public preferredCategories!: string[];
  public preferredSources!: string[];
  public notificationSettings!: {
    breakingNews: boolean;
    categoryUpdates: boolean;
    personalizedNews: boolean;
    pushNotifications: boolean;
  };
  public readingPreferences!: {
    fontSize: 'small' | 'medium' | 'large';
    darkMode: boolean;
    autoPlayVideos: boolean;
    showImages: boolean;
  };
  public location?: string;
  public isActive!: boolean;
  public lastLoginAt?: Date;
  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

User.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    email: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true
    },
    password: {
      type: DataTypes.STRING(255),
      allowNull: false
    },
    firstName: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    lastName: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    preferredCategories: {
      type: DataTypes.JSON,
      allowNull: false,
      defaultValue: []
    },
    preferredSources: {
      type: DataTypes.JSON,
      allowNull: false,
      defaultValue: []
    },
    notificationSettings: {
      type: DataTypes.JSON,
      allowNull: false,
      defaultValue: {
        breakingNews: true,
        categoryUpdates: false,
        personalizedNews: true,
        pushNotifications: true
      }
    },
    readingPreferences: {
      type: DataTypes.JSON,
      allowNull: false,
      defaultValue: {
        fontSize: 'medium',
        darkMode: false,
        autoPlayVideos: false,
        showImages: true
      }
    },
    location: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true
    },
    lastLoginAt: {
      type: DataTypes.DATE,
      allowNull: true
    }
  },
  {
    sequelize,
    tableName: 'users',
    timestamps: true,
    indexes: [
      {
        fields: ['email']
      },
      {
        fields: ['isActive']
      }
    ]
  }
);

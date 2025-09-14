# Hero Article Standardization System

## 📋 Overview

The Hero Article Standardization System provides a comprehensive framework for consistent, high-quality hero article display across the NewsLocal app. It ensures that hero articles are selected, validated, and displayed according to established standards and best practices.

## 🏗️ Architecture

### Core Components

1. **HeroArticleStandards** - Defines rules, criteria, and standards
2. **HeroArticleManager** - Manages hero article selection and validation
3. **StandardizedHeroArticleCard** - Implements the standardized hero article layout
4. **Quality Validation System** - Real-time quality monitoring and scoring

## 📊 Hero Article Types

### 1. Breaking News Hero
- **Usage**: Urgent, time-sensitive news
- **Priority**: Highest (1)
- **Styling**: Red badge with flame icon
- **Animation**: Pulse effect
- **Criteria**: Must be marked as breaking, recent (within 1 hour)

### 2. Featured Article Hero
- **Usage**: High-quality, important content
- **Priority**: High (2)
- **Styling**: Primary color badge with star icon
- **Animation**: None
- **Criteria**: High source credibility, recent content

### 3. Trending Article Hero
- **Usage**: Popular, engaging content
- **Priority**: Medium (3)
- **Styling**: Warning color badge with trending icon
- **Animation**: Glow effect
- **Criteria**: Recent publication, high engagement potential

### 4. Editorial Hero
- **Usage**: Opinion pieces, analysis
- **Priority**: Low (4)
- **Styling**: Secondary color badge
- **Animation**: None
- **Criteria**: Editorial content, moderate credibility

### 5. Sponsored Content Hero
- **Usage**: Promoted content
- **Priority**: Lowest (5)
- **Styling**: Success color badge
- **Animation**: None
- **Criteria**: Sponsored content, clear labeling

## 🎯 Layout Standards

### Dimensions
- **Aspect Ratio**: 16:9 (standard for hero articles)
- **Height**: 280pt (standard), 240-320pt (range)
- **Corner Radius**: 12pt (DesignSystem.Spacing.md)
- **Shadow**: 8pt radius, 4pt offset

### Spacing
- **Content Padding**: 20pt (DesignSystem.Spacing.lg)
- **Badge Spacing**: 12pt between badges
- **Meta Spacing**: 16pt between meta elements
- **Title Spacing**: 12pt around title
- **Element Spacing**: 4pt between small elements

### Typography
- **Title**: Title2 font, bold weight, 3 line limit
- **Category**: XS font, medium weight
- **Meta**: XS font, medium weight
- **Breaking Badge**: XS font, bold weight

## 🎨 Visual Standards

### Colors
- **Gradient**: Clear to black (0.3 to 0.7 opacity)
- **Category Background**: White 20% opacity
- **Breaking Background**: Breaking news red
- **Text Color**: White
- **Meta Text**: White 80% opacity
- **Separator**: White 60% opacity

### Placeholder
- **Gradient**: Primary color gradient
- **Icon**: Photo icon, 48pt, light weight
- **Color**: Secondary text color

## 📝 Content Standards

### Title Requirements
- **Minimum Length**: 20 characters
- **Maximum Length**: 120 characters
- **Quality Score**: Minimum 70/100
- **Engagement**: Should include engaging words
- **Clarity**: Prefer declarative statements

### Image Requirements
- **Aspect Ratio**: 16:9
- **Minimum Width**: 400px
- **Minimum Height**: 225px
- **Quality Score**: Minimum 60/100
- **Format**: High-resolution images preferred

### Category Support
- **Supported**: Politics, Business, Technology, Health, World, Sports, Entertainment
- **Priority**: Politics, Business, Technology, World (preferred)

## 🔍 Quality Validation

### Scoring System
- **Maximum Score**: 100 points
- **Minimum Threshold**: 75 points
- **Image Quality**: 30% weight
- **Title Quality**: 25% weight
- **Recency**: 20% weight
- **Source Credibility**: 15% weight
- **Category Relevance**: 10% weight

### Quality Levels
- **Excellent**: 90-100 points
- **Good**: 80-89 points
- **Acceptable**: 70-79 points
- **Poor**: 60-69 points
- **Unacceptable**: Below 60 points

### Validation Issues
- **Critical**: Missing image, title too short
- **High**: Low image quality, poor title
- **Medium**: Outdated content, low source credibility
- **Low**: Irrelevant category, title too long

## 🚀 Selection Criteria

### Basic Requirements
- **Age**: Maximum 24 hours old
- **Source Credibility**: Minimum 70%
- **Image**: Must have valid image URL
- **Title**: Must meet length requirements

### Priority Scoring
- **Breaking News**: 1.5x multiplier
- **Featured Content**: 1.2x multiplier
- **Trending Content**: 1.1x multiplier
- **Recency**: Bonus for recent content
- **Source Credibility**: Direct score impact
- **Category Preference**: Bonus for preferred categories

## 🛠️ Implementation

### Basic Usage
```swift
// Initialize manager
let heroManager = HeroArticleManager()

// Load hero article
heroManager.loadHeroArticle()

// Use in view
StandardizedHeroArticleCard(
    article: heroManager.currentHeroArticle!,
    heroType: heroManager.heroArticleType,
    validationResult: heroManager.validationResult,
    onTap: { /* handle tap */ }
)
```

### Quality Monitoring
```swift
// Check quality
if heroManager.meetsQualityStandards {
    // Article meets standards
}

// Get recommendations
let recommendations = heroManager.qualityRecommendations

// Get analytics
let analytics = heroManager.getHeroArticleAnalytics()
```

## 📊 Analytics

### Quality Metrics
- **Overall Score**: 0-100 quality rating
- **Quality Level**: Excellent, Good, Acceptable, Poor, Unacceptable
- **Issue Count**: Number of validation issues
- **Critical Issues**: Count of critical problems
- **Recommendations**: List of improvement suggestions

### Performance Tracking
- **Article Type**: Breaking, Featured, Trending, Editorial, Sponsored
- **Selection Time**: Time taken to select article
- **Validation Time**: Time taken to validate article
- **Quality Trends**: Historical quality data

## 🔧 Customization

### Adding New Hero Types
1. Add new case to `HeroArticleType` enum
2. Define styling in `styling(for:)` method
3. Update selection criteria if needed
4. Add validation rules if required

### Modifying Quality Standards
1. Update scoring weights in `Quality` struct
2. Adjust minimum thresholds
3. Add new validation issues
4. Update quality level ranges

### Custom Styling
1. Modify `HeroArticleStyling` struct
2. Update badge colors and text
3. Add custom animations
4. Adjust priority levels

## 🎯 Best Practices

### Content Selection
- Prioritize breaking news for immediate impact
- Use high-quality images with proper aspect ratio
- Ensure titles are engaging and descriptive
- Verify source credibility before selection

### Quality Assurance
- Validate articles before display
- Monitor quality scores regularly
- Address critical issues immediately
- Use recommendations to improve content

### Performance Optimization
- Cache validation results
- Use background processing for heavy operations
- Implement lazy loading for images
- Monitor memory usage

## 🚨 Troubleshooting

### Common Issues
- **Low Quality Score**: Check image quality and title clarity
- **No Hero Article**: Verify selection criteria and content availability
- **Validation Errors**: Check article data completeness
- **Performance Issues**: Monitor memory usage and processing time

### Debugging
- Enable quality details sheet for inspection
- Check validation result details
- Monitor analytics data
- Review selection criteria

## 📈 Future Enhancements

### Planned Features
- **A/B Testing**: Test different hero article types
- **Machine Learning**: AI-powered quality scoring
- **Real-time Updates**: Live quality monitoring
- **Advanced Analytics**: Detailed performance metrics

### Integration Opportunities
- **Content Management**: Integration with CMS
- **Analytics Platforms**: Google Analytics, Mixpanel
- **Image Processing**: Automatic image optimization
- **Content Delivery**: CDN integration

## 📚 Related Documentation

- [Homepage Article Standardization](HOMEPAGE_ARTICLE_STANDARDIZATION.md)
- [Design System Guidelines](DESIGN_SYSTEM.md)
- [Quality Assurance Process](QUALITY_ASSURANCE.md)
- [Analytics Implementation](ANALYTICS.md)

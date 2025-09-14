# NewsLocal 📰

**NewsBreak Replika - Modern Haber Uygulaması**

NewsLocal, NewsBreak benzeri modern bir haber uygulamasıdır. SwiftUI 6.0 ve Node.js 18+ teknolojileri kullanılarak geliştirilmiştir.

## 🎯 Proje Hedefleri

- **Modern UI/UX**: SwiftUI 6.0 ile native iOS deneyimi
- **Real-time Updates**: WebSocket ile anlık haber güncellemeleri
- **Personalization**: AI destekli kişiselleştirilmiş haber önerileri
- **Offline Support**: Çevrimdışı okuma ve senkronizasyon
- **Performance**: Optimize edilmiş performans ve hızlı yükleme

## 🏗️ Teknoloji Stack

### **Frontend (iOS)**
- **SwiftUI 6.0** - Modern UI framework
- **iOS 18.5+** - En son iOS özellikleri
- **Combine** - Reactive programming
- **Core Data** - Local storage
- **URLSession** - Network layer
- **UserNotifications** - Push notifications
- **Core Location** - Location services

### **Backend**
- **Node.js 18+** - Runtime environment
- **Express.js** - Web framework
- **TypeScript** - Type safety
- **SQLite/PostgreSQL** - Database
- **Redis** - Caching
- **Socket.io** - Real-time communication
- **JWT** - Authentication

### **Development Tools**
- **Xcode** - iOS development
- **VS Code** - Backend development
- **Git** - Version control
- **Docker** - Containerization
- **Jest** - Testing
- **ESLint** - Code linting

## 📱 Özellikler

### **Temel Özellikler**
- ✅ Haber kategorileri ve filtreleme
- ✅ Arama ve öneriler
- ✅ Favoriler ve kaydetme
- ✅ Dark/Light mode
- ✅ Offline okuma
- ✅ Push notifications

### **Gelişmiş Özellikler**
- ✅ Real-time breaking news
- ✅ AI destekli öneriler
- ✅ Sosyal paylaşım
- ✅ Çoklu dil desteği
- ✅ Accessibility
- ✅ Analytics

## 🚀 Kurulum

### **Gereksinimler**
- macOS 14.0+
- Xcode 15.0+
- Node.js 18.0+
- iOS Simulator 18.5+

### **Frontend Kurulum**
```bash
# iOS projesi açma
open NewsLocal.xcodeproj

# Simulator'da çalıştırma
⌘ + R
```

### **Backend Kurulum**
```bash
# Backend klasörüne git
cd backend

# Dependencies yükle
npm install

# Environment variables ayarla
cp .env.example .env

# Development server başlat
npm run dev
```

## 📂 Proje Yapısı

```
NewsLocal/
├── Core/                    # Core functionality
│   ├── Models/             # Data models
│   ├── Services/           # Business logic
│   ├── Utils/              # Utilities
│   └── Extensions/         # Swift extensions
├── Features/               # Feature modules
│   ├── Home/              # Home screen
│   ├── News/              # News detail
│   ├── Categories/        # Categories
│   ├── Search/            # Search
│   ├── Profile/           # User profile
│   └── Settings/          # App settings
├── Shared/                # Shared components
│   ├── Components/        # Reusable UI components
│   ├── Views/             # Base views
│   └── Resources/         # Assets, fonts, etc.
├── Data/                  # Data layer
│   ├── Mock/              # Mock data
│   ├── Network/           # API services
│   └── Storage/           # Local storage
└── Tests/                 # Test files
```

## 🎨 Design System

### **Renk Paleti**
- **Primary**: #007AFF (iOS Blue)
- **Secondary**: #5856D6 (iOS Purple)
- **Success**: #34C759 (iOS Green)
- **Warning**: #FF9500 (iOS Orange)
- **Error**: #FF3B30 (iOS Red)

### **Typography**
- **Headline**: SF Pro Display, 28pt, Bold
- **Title**: SF Pro Display, 22pt, Semibold
- **Body**: SF Pro Text, 17pt, Regular
- **Caption**: SF Pro Text, 13pt, Regular

### **Spacing System**
- **xs**: 4px
- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px
- **xxl**: 48px

## 🔧 Development Standards

### **Code Standards**
- **Naming**: PascalCase (classes), camelCase (variables)
- **File Structure**: One class per file
- **Documentation**: Comprehensive comments
- **Testing**: Unit tests for all services
- **Error Handling**: Proper error management

### **Git Workflow**
- **Main Branch**: Production-ready code
- **Feature Branches**: New features
- **Commit Messages**: Conventional commits
- **Pull Requests**: Code review required

## 📊 Testing Strategy

### **Unit Tests**
- Service layer testing
- Model validation
- Utility function testing

### **Integration Tests**
- API integration
- Database operations
- Real-time features

### **UI Tests**
- User flow testing
- Accessibility testing
- Performance testing

## 🚀 Deployment

### **iOS App Store**
- Automated build process
- TestFlight distribution
- App Store submission

### **Backend**
- Docker containerization
- AWS/GCP deployment
- CI/CD pipeline

## 📈 Monitoring & Analytics

### **Performance Monitoring**
- App launch time
- Memory usage
- Network performance
- Crash reporting

### **User Analytics**
- User engagement
- Feature usage
- Error tracking
- A/B testing

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Magnus Magi** - Lead Developer
- **AI Assistant** - Development Support

## 📞 Support

- **Email**: support@newslocal.com
- **Issues**: GitHub Issues
- **Documentation**: [Wiki](wiki)

---

**NewsLocal** - Modern haber deneyimi için tasarlandı! 📰✨
# WorldBreak

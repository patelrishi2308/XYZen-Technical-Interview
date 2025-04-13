# XYZen Technical Interview - Tune Stack

A Flutter-based music social media application developed as part of the XYZen technical interview process. This project demonstrates modern Flutter development practices, clean architecture, and integration with Firebase services.

## 🚀 Features

- **Authentication System**
  - Firebase Authentication integration
  - Profile management
  - Secure user sessions

- **Social Features**
  - Create and share music-related posts
  - User profile customization
  - Interactive home feed
  - Bottom navigation for seamless experience

- **Technical Features**
  - Firebase Analytics and Core integration
  - Multi-environment support (Development/Production)
  - Responsive UI design
  - Media handling (images and files)
  - Offline data persistence
  - Network connectivity management
  - Custom error handling

## 🛠️ Technical Stack

- **Framework**: Flutter (SDK >=3.0.0)
- **State Management**: Flutter Riverpod 2.6.1
- **Backend Services**: 
  - Firebase Core 3.13.0
  - Firebase Analytics 11.4.5
  - Firebase Auth 5.5.2
  - Cloud Firestore 5.6.6
- **UI/UX**:
  - Material Design
  - Custom SVG assets
  - Heebo font family
  - Gap 3.0.1 for spacing
  - Toastification 3.0.2 for notifications
- **Development Tools**:
  - Very Good Analysis 5.1.0
  - Flutter Gen Runner 5.10.0
  - Build Runner 2.4.9
  - Import Sorter 4.6.0

## 🏗️ Project Structure

```
lib/
├── features/ # Core feature modules
│ ├── auth/ # Authentication
│ ├── home/ # Home screen
│ ├── profile/ # User profiles
│ ├── create_post/ # Post creation
│ ├── splash/ # Splash screen
│ ├── common/ # Shared feature components
│ └── bottom_nav_bar/ # Navigation
├── config/ # Configuration and assets
├── constants/ # App constants
├── helpers/ # Helper utilities
├── services/ # Service layer
└── widgets/ # Reusable widgets
```

## 🚦 Getting Started

### Prerequisites

- Flutter SDK >=3.0.0
- Firebase project setup
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/patelrishi2308/XYZen-Technical-Interview.git
cd XYZen-Technical-Interview
```

2. Navigate to the project directory
```bash
cd "Tune Stack"
```

3. Install dependencies
```bash
flutter pub get
```

4. Setup environment files
Create two environment files in the root directory:
- `.env.development`
- `.env.production`

5. Configure Firebase
- Add your `google-services.json` to `android/app/`
- Configure Firebase project settings with package name:
  - Development: `com.tunestack.app.dev`
  - Production: `com.tunestack.app`

6. Run the app
```bash
# Development
flutter run --flavor dev

# Production
flutter run --flavor prod
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- 🚧 Web (in development)
- 🚧 macOS (in development)
- 🚧 Linux (in development)

## 🔄 Development Features

- **Code Quality**
  - Very Good Analysis for strict code analysis
  - Import sorting for organized imports
  - Build runner for code generation

- **Build Configuration**
  - Automated version management
  - Development and Production flavors
  - Environment-specific configurations

- **Asset Management**
  - Flutter Gen for type-safe asset access
  - SVG support
  - Custom font integration (Heebo)

## 📝 Notes

- This is a technical interview project demonstrating Flutter development capabilities
- The project uses Flutter 3.0+ features and modern development practices
- Firebase configuration is required for full functionality

## 🤝 Contributing

This is a technical interview project and is not open for contributions.

## 📄 License

This project is part of a technical interview process and is not licensed for public use.
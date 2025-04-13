# Tune Stack

A modern Flutter-based music social media application that allows users to share and discover music-related content.

## 🎯 Key Features

- **User Authentication**
  - Firebase Authentication
  - Profile management
  - Secure sessions

- **Core Features**
  - Music post creation and sharing
  - User profiles
  - Interactive feed
  - Media file handling
  - Offline support

## 🛠️ Tech Stack

- **Core**
  - Flutter SDK >=3.0.0
  - Riverpod 2.6.1 (State Management)

- **Firebase Services**
  - Firebase Core 3.13.0
  - Firebase Auth 5.5.2
  - Cloud Firestore 5.6.6
  - Firebase Analytics 11.4.5

- **UI/UX**
  - Material Design
  - SVG support
  - Custom Heebo font
  - Responsive layouts

## 📁 Project Structure

```
lib/
├── features/
│ ├── auth/ # Authentication
│ ├── home/ # Home feed
│ ├── profile/ # User profiles
│ ├── create_post/ # Post creation
│ ├── splash/ # App initialization
│ └── common/ # Shared components
├── config/ # App configuration
├── services/ # Business logic
└── widgets/ # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK >=3.0.0
- Firebase project
- Android Studio/VS Code

### Setup Steps

1. **Clone Repository**
```bash
git clone https://github.com/patelrishi2308/XYZen-Technical-Interview.git
cd XYZen-Technical-Interview
```

2. **Install Dependencies**
```bash
cd "Tune Stack"
flutter pub get
```

3. **Environment Setup**
- Create `.env.development` and `.env.production`
- Add Firebase configuration
- Place `google-services.json` in `android/app/`

4. **Run Application**
```bash
# Development
flutter run --flavor dev

# Production
flutter run --flavor prod
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- 🚧 Web, macOS, Linux (in development)

## 🔐 Package Names

- Development: `com.tunestack.app.dev`
- Production: `com.tunestack.app`

## 📝 Note

This project is part of a technical interview process and demonstrates Flutter development capabilities using modern architecture and best practices.

## 🤝 Contributing

This is a technical interview project and is not open for contributions.

## 📄 License

This project is part of a technical interview process and is not licensed for public use.
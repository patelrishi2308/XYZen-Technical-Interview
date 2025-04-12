# Tune Stack

Tune Stack is a modern social media application built with Flutter, designed for music enthusiasts to share and discover music-related content.

## 🚀 Features

- **Authentication System**
  - Secure user authentication using Firebase Auth
  - Profile management
  - PIN code verification

- **Social Features**
  - Create and share posts
  - User profiles
  - Home feed
  - Interactive bottom navigation

- **Technical Features**
  - Firebase integration (Analytics, Auth, Firestore)
  - Environment-based configuration (Development/Production)
  - Localization support
  - Responsive design
  - File and image picking capabilities
  - Offline data persistence
  - Internet connectivity handling

## 🛠️ Built With

- **Framework**: Flutter (SDK >=3.0.0)
- **State Management**: Flutter Riverpod
- **Backend Services**: Firebase
- **Storage**: Cloud Firestore
- **UI Components**: Custom widgets and Material Design
- **Asset Management**: Flutter Gen
- **Utilities**:
  - master_utility
  - easy_localization
  - toastification
  - connectivity_plus
  - permission_handler

## 🏗️ Project Structure

## 🚦 Getting Started

### Prerequisites

- Flutter SDK >=3.0.0
- Firebase project setup
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
```bash
git clone https://github.com/patelrishi2308/XYZen-Technical-Interview.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Setup environment files
- Create `.env.development` and `.env.production` files
- Configure Firebase credentials

4. Run the app
```bash
# For development
flutter run --flavor dev

# For production
flutter run --flavor prod
```

## 🔐 Environment Configuration

The app uses different environment configurations for development and production:
- `.env.development` - Development environment variables
- `.env.production` - Production environment variables

## 📱 Supported Platforms

- Android
- iOS
- Web (in progress)
- macOS (in progress)
- Linux (in progress)

## 🔄 CI/CD

The project includes:
- Code analysis using `very_good_analysis`
- Automated build versioning
- Multiple flavor support (dev/prod)
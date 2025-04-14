# Tune Stack

A modern Flutter application for music enthusiasts, featuring AI-powered music recommendations, social sharing, and personalized playlists.

## 🚀 Features

- **AI-Powered Music Assistant**: Get personalized music recommendations and insights using OpenAI's GPT-3.5
- **Music Player**: Stream and manage your favorite tracks with a beautiful UI
- **Social Integration**: Share music with friends and discover new tracks
- **Offline Support**: Download and listen to music without internet connection
- **Cross-Platform**: Available on Android, iOS, and Web
- **Modern Architecture**: Built with Flutter and following clean architecture principles

## 🛠 Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Backend**: Firebase & Supabase
- **AI Integration**: OpenAI API
- **Local Storage**: Shared Preferences
- **Audio Playback**: Just Audio
- **UI Components**: Custom design system with Heebo font family

## 📦 Dependencies

Key dependencies include:
- `flutter_riverpod`: State management
- `firebase_core` & `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `supabase_flutter`: Backend services
- `dart_openai`: AI integration
- `just_audio`: Audio playback
- `easy_localization`: Internationalization
- `envied`: Environment configuration

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase account
- Supabase account
- OpenAI API key

### Installation

1. Clone the repository:
```bash
git clone https://github.com/patelrishi2308/XYZen-Technical-Interview.git
cd tune_stack
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment:
- Copy `.env.example` to `.env`
- Add your API keys and configuration

4. Generate environment files:
```bash
flutter pub run build_runner build
```

5. Run the app:
```bash
flutter run
```

## 🏗 Project Structure

```
lib/
├── config/          # Configuration files
├── core/            # Core utilities and constants
├── features/        # Feature modules
│   ├── auth/       # Authentication
│   ├── home/       # Home screen
│   ├── music/      # Music player
│   ├── profile/    # User profile
│   └── chatbot/    # AI assistant
├── shared/          # Shared widgets and utilities
└── main.dart        # Application entry point
```

## 🔧 Configuration

The app uses environment variables for configuration. Create a `.env` file with:

```env
BASE_URL=your_base_url
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_key
OPENAI_API_KEY=your_openai_key
```

## 🧪 Testing

Run tests using:
```bash
flutter test
```


## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is created for the interview process only.

## 👥 Authors

- Your Name - [@patelrishi2308](https://github.com/patelrishi2308)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- OpenAI for the AI capabilities
- All contributors and supporters 
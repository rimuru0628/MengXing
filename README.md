# MengXing 梦行

**Daily Exercise & Walking Tracker**

A complete mobile fitness app built with Flutter and Firebase — tracking daily steps, walking sessions, workouts, streaks, achievements, and more.

---

## Features

| Feature | Details |
|---|---|
| 🔐 Auth | Email/password, Google Sign-In, Apple Sign-In, email verification |
| 🏠 Home | Daily activity dashboard with steps, distance, walks, calories, streaks |
| 🚶 Walk | Manual & automatic tracking, GPS routes, session history |
| 💪 Exercise | Daily workout, exercise library, interactive workout player |
| 📊 Progress | Daily/weekly/monthly charts, activity calendar |
| 🔥 Streaks | Consecutive-day tracking with current + best streak |
| 🏆 Achievements | 20 badge types unlocked automatically |
| 🎯 Challenges | Daily, weekly, and monthly challenges |
| 🤖 AI Assistant | Fitness coach powered by OpenAI (configurable) |
| 🔔 Notifications | Reminders, goal alerts, streak warnings |
| 📴 Offline | Local caching, Firestore sync on reconnect |
| 🌙 Dark Mode | Full Material 3 light and dark theme |

---

## Tech Stack

- **Flutter** 3.x / **Dart** 3.x — Material 3 UI
- **Firebase** — Auth, Firestore, Storage, FCM, Cloud Functions
- **Riverpod** — state management
- **GoRouter** — navigation
- **Health / HealthKit / Health Connect** — device step & activity data
- **fl_chart** — charts
- **table_calendar** — activity calendar
- **Hive + SharedPreferences** — offline/local storage

---

## Getting Started

### 1. Prerequisites

```bash
flutter --version   # 3.16+
node --version      # 18+ (for Cloud Functions)
firebase --version  # Firebase CLI installed
```

### 2. Clone and install Flutter dependencies

```bash
cd MengXing
flutter pub get
```

### 3. Set up Firebase

1. Go to [console.firebase.google.com](https://console.firebase.google.com) and create a project.
2. Enable **Authentication** (Email/Password, Google, Apple).
3. Enable **Firestore**, **Storage**, **Cloud Messaging**, **Cloud Functions**.
4. Run the FlutterFire CLI to generate credentials:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` with your real credentials.

5. Download `google-services.json` → `android/app/`
6. Download `GoogleService-Info.plist` → `ios/Runner/`

### 4. Deploy Firestore rules and indexes

```bash
firebase deploy --only firestore:rules,firestore:indexes
firebase deploy --only storage
```

### 5. Deploy Cloud Functions

```bash
cd functions
npm install
npm run build
cd ..
firebase deploy --only functions
```

### 6. Run the app

```bash
flutter run
```

---

## AI Assistant Setup

The AI assistant uses OpenAI's API (or any compatible endpoint).

1. Get an API key from [platform.openai.com](https://platform.openai.com).
2. For security, store the key in **Firebase Remote Config** or pass it through a Cloud Function — never hardcode it in the app.
3. The `AiService` in `lib/services/ai/ai_service.dart` has a `setApiKey()` method — call it after loading from your secure source.

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App + Firebase constants, routes
│   ├── extensions/      # BuildContext extensions
│   ├── router/          # GoRouter configuration
│   ├── shell/           # Bottom navigation shell
│   ├── theme/           # Material 3 light/dark theme
│   └── utils/           # Date, fitness calculation utilities
├── features/
│   ├── ai_assistant/    # AI chat screen + provider
│   ├── achievements/    # Achievement badges
│   ├── auth/            # Login, register, forgot password
│   ├── challenges/      # Daily/weekly challenges
│   ├── exercise/        # Library, daily workout, player, history
│   ├── home/            # Dashboard
│   ├── notifications/   # Notification providers
│   ├── onboarding/      # Intro screens + permissions
│   ├── profile/         # Setup, edit, goals, settings
│   ├── progress/        # Charts, calendar, streaks
│   └── walk/            # Session, summary, history
├── services/
│   ├── ai/              # AI service (OpenAI)
│   ├── background/      # Background sync
│   ├── firebase/        # Auth service, Firestore service
│   ├── health/          # Health Connect / HealthKit
│   ├── local_storage/   # SharedPreferences wrapper
│   └── notifications/   # Local notifications
└── shared/
    ├── models/          # Data models (Profile, Activity, Walk, etc.)
    ├── providers/       # Global providers (services, theme)
    ├── screens/         # Splash screen
    └── widgets/         # Reusable UI components

functions/src/           # Firebase Cloud Functions (TypeScript)
firestore.rules          # Firestore security rules
storage.rules            # Firebase Storage rules
firestore.indexes.json   # Composite indexes
```

---

## Safety & Health Disclaimer

MengXing is a fitness tracking tool, not a medical device.

- Calorie values are estimates.
- Step and distance measurements vary by device.
- Stop exercising if you experience pain, dizziness, or unusual symptoms.
- Consult a healthcare professional before starting a new exercise program.
- The AI assistant provides general fitness guidance only and does not replace professional medical advice.

---

## License

MIT License — see `LICENSE` for details.

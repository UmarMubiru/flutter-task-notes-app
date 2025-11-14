# Task Notes Manager

A Flutter application for managing tasks and notes with local database persistence, built as part of a mobile networks project.

## 📱 About

Task Notes Manager is a cross-platform mobile application that allows users to create, manage, and track their tasks and notes. The app features a modern UI with dark mode support, priority-based task organization, and persistent local storage.

## ✨ Features

- **Task Management**: Create, view, update, and delete tasks
- **Priority Levels**: Assign Low, Medium, or High priority to tasks
- **Task Completion**: Mark tasks as completed with checkbox toggle
- **Dark Mode**: Toggle between light and dark themes (persisted across app restarts)
- **Local Database**: SQLite database for persistent storage
- **Cross-Platform**: Works on Windows, Android, iOS, and Web
- **Modern UI**: Beautiful gradient design with Material 3 components
- **Form Validation**: Input validation for task creation
- **Error Handling**: Comprehensive error handling with user-friendly messages

## 🛠️ Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **Database**: 
  - SQLite (via `sqflite` for mobile)
  - SQLite FFI (via `sqflite_common_ffi` for desktop)
  - SharedPreferences (for web fallback)
- **State Management**: StatefulWidget
- **Storage**: SharedPreferences for theme persistence

## 📦 Dependencies

- `flutter`: SDK
- `sqflite`: ^2.3.0 - SQLite database for mobile platforms
- `sqflite_common_ffi`: ^2.3.0 - SQLite database for desktop platforms
- `shared_preferences`: ^2.2.2 - Local key-value storage
- `path_provider`: ^2.1.1 - Path utilities for file system access
- `path`: ^1.8.3 - Path manipulation utilities
- `ffi`: ^2.1.0 - Foreign Function Interface for native code

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- For Windows: Developer Mode enabled

### Installation

1. Clone the repository:
```bash
git clone https://github.com/UmarMubiru/flutter-task-notes-app.git
cd flutter-task-notes-app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
# For Windows Desktop
flutter run -d windows

# For Android Emulator
flutter run -d android

# For iOS Simulator (macOS only)
flutter run -d ios

# For Web/Chrome
flutter run -d chrome
```

## 📱 Screenshots

### Home Screen
- Welcome message: "My Tasks & Notes"
- Dark mode toggle switch
- List of tasks with priority indicators
- Floating Action Button to add new tasks

### Add Task Screen
- Title input field
- Priority dropdown (Low, Medium, High)
- Description text area
- Submit button with loading indicator

## 🗄️ Database Schema

The app uses a SQLite database with the following schema:

```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  priority TEXT NOT NULL,
  description TEXT NOT NULL,
  isCompleted INTEGER NOT NULL
)
```

## 🏗️ Project Structure

```
lib/
├── models/
│   └── task_item.dart          # TaskItem data model with JSON serialization
├── helpers/
│   ├── database_helper.dart     # Main database helper (platform-agnostic)
│   ├── database_mobile.dart     # Mobile platform implementation
│   ├── database_desktop.dart    # Desktop platform implementation
│   ├── database_web.dart        # Web platform implementation
│   ├── platform_detector.dart  # Platform detection utility
│   └── platform_stub.dart      # Web platform stub
└── screens/
    ├── home_screen.dart         # Main home screen with task list
    └── add_task_screen.dart    # Form screen for adding new tasks
```

## 🎨 UI Features

- **Gradient AppBar**: Beautiful indigo gradient on app bars
- **Priority Colors**: 
  - High: Red
  - Medium: Orange
  - Low: Green
- **Card Design**: Rounded corners with elevation
- **Color-coded Priority**: Visual indicators for task priorities
- **Responsive Layout**: Adapts to different screen sizes

## 🔧 Platform Support

- ✅ **Windows Desktop**: Full SQLite support via FFI
- ✅ **Android**: Native SQLite support
- ✅ **iOS**: Native SQLite support
- ✅ **Web/Chrome**: SharedPreferences fallback storage

## 👤 Author

**MUBIRU UMAR**  
**Registration**: 23/U/11419/EVE

## 📝 License

This project is part of an academic assignment for mobile networks course.

## 🤝 Contributing

This is an academic project. Contributions and suggestions are welcome!

## 📄 Commit History

The project follows a structured commit history:
- Initial setup
- TaskItem model with JSON serialization
- SQLite database integration
- UI screens and navigation
- Multi-platform database support
- Error handling and user feedback

---

**Note**: This application was developed as part of a mobile networks project assignment, demonstrating proficiency in Flutter development, local database management, and cross-platform application design.

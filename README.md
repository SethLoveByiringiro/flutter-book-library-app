# Flutter Book Library App

A cross-platform mobile application developed using Flutter that allows users to manage their personal book library. The app includes features to add, edit, delete, and view books. Users can also rate books and mark them as read or unread. User preferences such as the sorting order of the book list are stored using Shared Preferences.

## Key Features

1. **UI Design:**
   - Use Flutter's Material Design widgets for a cohesive look.
   - Implement a home screen with a list of books.
   - Create screens for adding/editing book details.
   - Design a book detail view.
   - Implement a settings screen.

2. **Data Persistence (SharedPreferences):**
   - Use `shared_preferences` package to store user preferences.
   - Save sorting preferences (by title, author, rating).
   - Store theme preferences (light/dark mode).

3. **Data Management (SQLite):**
   - Use `sqflite` package for local database.
   - Implement CRUD operations for books.
   - Create a data access layer to manage database operations.

4. **State Management:**
   - Use `Provider` or `Riverpod` for state management.

5. **Additional Features:**
   - Add, edit, and delete books.
   - Rate books and mark as read/unread.
   - Sort books based on different criteria.
   - Search functionality.
   - Theme switching (light/dark mode).

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart: Included with Flutter
- A code editor (e.g., Visual Studio Code, Android Studio)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/SethLoveByiringiro/flutter-book-library-app.git
   cd flutter-book-library-app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   flutter run
   ```

### Project Structure

- `lib/`: Main application code.
  - `models/`: Data models.
  - `providers/`: State management providers.
  - `screens/`: UI screens.
  - `widgets/`: Reusable UI components.
- `assets/`: Application assets (images, fonts, etc.).
- `test/`: Unit and widget tests.

### Implementation Steps

1. **Set up the project structure:**
   - Organize the project into directories for models, providers, screens, and widgets.

2. **Design and implement the UI components:**
   - Home screen, add/edit book screen, book detail view, settings screen.

3. **Implement data persistence for user preferences:**
   - Use `shared_preferences` to save sorting and theme preferences.

4. **Set up the local database and CRUD operations:**
   - Use `sqflite` for local database operations.

5. **Implement state management:**
   - Use `Provider` or `Riverpod` to manage app state.

6. **Add sorting and filtering functionality:**
   - Allow users to sort books by title, author, and rating.

7. **Implement search feature:**
   - Provide a search bar to filter books by title or author.

8. **Add theme switching capability:**
   - Implement light and dark mode switching.

9. **Test the application on both iOS and Android:**
   - Ensure the app works seamlessly on both platforms.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For any questions or suggestions, please contact [sethlovebyiringiro@gmail.com](mailto:sethlovebyiringiro@gmail.com).

import 'package:book_library_app/app_state.dart';
import 'package:book_library_app/providers/book_provider.dart';
import 'package:book_library_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Book Library App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: WelcomeScreen(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'app/expense_tracker_app.dart';
import 'core/theme/app_theme.dart';

/// Main entry point
/// Demonstrates Material 3 theming and app initialization
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Theme mode management (can be extended to use provider/bloc)
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',

      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,

      // Home screen
      home: const ExpenseTrackerApp(),
    );
  }
}

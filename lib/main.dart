import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ADDED: Import for shared preferences

void main() {
  runApp(const MyApp());
}

// CHANGED: MyApp is now a StatefulWidget to manage theme state
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ADDED: State variable to hold the current theme mode
  ThemeMode _themeMode = ThemeMode.system; // Default to system preference

  @override
  void initState() {
    super.initState();
    _loadThemeMode(); // ADDED: Load saved theme preference when app starts
  }

  // ADDED: Method to load the theme mode from SharedPreferences
  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString('themeMode'); // Retrieve saved string
    if (theme == 'light') {
      setState(() {
        _themeMode = ThemeMode.light; // Set to light mode
      });
    } else if (theme == 'dark') {
      setState(() {
        _themeMode = ThemeMode.dark; // Set to dark mode
      });
    } else {
      // If no preference or 'system' was saved, default to system
      setState(() {
        _themeMode = ThemeMode.system;
      });
    }
  }

  // ADDED: Method to update and save the theme mode
  void _setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
      default:
        themeString = 'system';
        break;
    }
    await prefs.setString('themeMode', themeString); // Save the new theme string
    setState(() {
      _themeMode = mode; // Update the internal state
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes', // CHANGED: Updated title for consistency
      // ADDED: Define your light theme
      theme: ThemeData(
        brightness: Brightness.light, // Explicitly light
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white, // Text/icon color on app bar
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        scaffoldBackgroundColor: Colors.grey[50], // Light background for the overall scaffold
        // Add more light theme properties as needed
      ),
      // ADDED: Define your dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Explicitly dark
        primarySwatch: Colors.indigo, // A different primary color for dark mode
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo[900], // Darker app bar
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.grey[900], // Dark background for scaffold
        cardColor: Colors.grey[850], // Darker background for cards
        cardTheme: CardTheme(
          color: Colors.grey[850], // Consistent card color for dark mode
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        // Add more dark theme properties as needed
      ),
      // ADDED: Use the _themeMode state to control the app's theme
      themeMode: _themeMode,
      home: HomeScreen(
        // ADDED: Pass the theme setter function down to HomeScreen
        setThemeMode: _setThemeMode,
        // ADDED: Pass the current theme mode to HomeScreen for UI logic
        currentThemeMode: _themeMode,
      ),
    );
  }
}
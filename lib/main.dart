import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/main_screen.dart';
import 'package:tasky/services/preferences_manager.dart';
import 'package:tasky/tasks_screen.dart';
import 'package:tasky/theme/dark_theme.dart';
import 'package:tasky/theme/light_theme.dart';
import 'package:tasky/theme/theme_controller.dart';
import 'package:tasky/user_details.dart';
import 'package:tasky/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager().init();
  ThemeController().init();
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = PreferencesManager().getString(StorageKey.username);
  // test tasks
  print(username);
  runApp(MainApp(username: username));
}

class MainApp extends StatelessWidget {
  MainApp({super.key, this.username});
  String? username;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode themeMode, Widget? child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body:
                // MainScreen(),
                username == null ? WelcomeScreen() : MainScreen(),
          ),
        );
      },
    );
  }
}

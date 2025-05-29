import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/main_screen.dart';
import 'package:tasky/tasks_screen.dart';
import 'package:tasky/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  // test tasks
  print(username);
  runApp(MainApp(username: username));
}

class MainApp extends StatelessWidget {
  MainApp({super.key, this.username});
  String? username;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF181818),

        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Color(0xFF15B86C);
            }
            return Colors.white;
          }),
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return Color(0xFF9E9E9E);
          }),
          trackOutlineColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.transparent;
            }
            return Color(0xFF9E9E9E);
          }),
          trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return 0;
            }
            return 2;
          }),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF15B86C),
            foregroundColor: Color(0xFFFFFCFC),
            fixedSize: Size(MediaQuery.of(context).size.width, 40),
          ),
        ),
        textTheme: TextTheme(
          displayMedium: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            color: Color(0xFFFFFCFC),
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
          ),
          displaySmall: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: Color(0xFFFFFCFC),
            letterSpacing: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: GoogleFonts.plusJakartaSans(
            color: Color(0xFF6D6D6D),
            fontSize: 17,
            letterSpacing: 2,
          ),
          fillColor: Color(0xFF282828),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF181818),
          selectedItemColor: Color(0xFF15B86C),
          unselectedItemColor: Color(0xFFC6C6C6),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:
            // MainScreen(),
            username == null ? WelcomeScreen() : MainScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tasky/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF181818),
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
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: WelcomeScreen()),
    );
  }
}

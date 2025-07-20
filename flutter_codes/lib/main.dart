import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abdulhakim She\'rlari',
      theme: ThemeData(
        brightness: Brightness.light, // Umumiy tema light mode
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white, // Orqa fon oq
        fontFamily: 'Inter', // Inter shrifti
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // AppBar matn rangi qora
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        // BottomNavigationBarThemeData ni shu yerda olib tashladik, chunki MainScreen ichida dinamik boshqaramiz
        cardTheme: CardThemeData(
          color: Colors.grey[100], // Kartalar uchun och kulrang fon
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Yumaloq burchaklar
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200], // Qidiruv maydoni foni
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Colors.black54),
        ),
      ),
      home: const SplashScreen(), // Splash Screen'dan boshlash
    );
  }
}

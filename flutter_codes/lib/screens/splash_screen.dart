import 'package:flutter/material.dart';

import '../models/poem.dart';
import '../services/poem_service.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PoemService _poemService = PoemService();
  double _loadingProgress = 0.0;
  String _loadingMessage = 'Ma\'lumotlar yuklanmoqda...';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      // 1. Kategoriyalarni yuklash
      setState(() { _loadingMessage = 'Kategoriyalar yuklanmoqda...'; _loadingProgress = 0.2; });
      final categories = await _poemService.fetchCategories();
      List<Poem> allPoems = [];
      for (var category in categories) {
        allPoems.addAll(category.poems);
      }

      // 2. She'r matnlarini oldindan yuklash
      setState(() { _loadingMessage = 'She\'rlar matni yuklanmoqda...'; _loadingProgress = 0.5; });
      await _poemService.preloadAllPoemContents(allPoems);

      // 3. Sevimlilar holatini yuklash va o'rnatish
      setState(() { _loadingMessage = 'Sevimlilar yuklanmoqda...'; _loadingProgress = 0.8; });
      // preloadAllPoemContents ichida isLiked o'rnatilgani uchun bu yerda alohida shart emas.

      setState(() { _loadingMessage = 'Tayyor!'; _loadingProgress = 1.0; });

      // Yuklash tugagach, MainScreen'ga o'tish
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(
              allPoems: allPoems,
              categories: categories,
              poemService: _poemService,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Splash Screen yuklashda xato: $e');
      setState(() {
        _isError = true;
        _loadingMessage = 'Xato yuz berdi: ${e.toString().split(':').last.trim()}';
        _loadingProgress = 0.0; // Xato bo'lsa progressni nolga qaytarish
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Splash screen foni qora
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '📖', // Emoji icon
              style: TextStyle(fontSize: 80, color: Colors.cyanAccent),
            ),
            const SizedBox(height: 20),
            const Text(
              'Abdulhakim She\'rlari',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.cyanAccent,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'She\'riyat olamiga sayohat', // Ilova slogani
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _loadingProgress,
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _loadingMessage,
              style: TextStyle(
                fontSize: 16,
                color: _isError ? Colors.redAccent : Colors.white70,
              ),
            ),
            if (_isError)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isError = false;
                      _loadingProgress = 0.0;
                      _loadingMessage = 'Qayta urinish...';
                    });
                    _loadInitialData(); // Qayta yuklashga urinish
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text('Qayta urinish', style: TextStyle(color: Colors.black)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

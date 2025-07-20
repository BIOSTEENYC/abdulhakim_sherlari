import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/poem.dart';
import '../services/poem_service.dart';
import '../utils/notifiers.dart';
import 'about_screen.dart';
import 'ai_screen.dart';
import 'poems_screen.dart';
import 'reels_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  final List<Category> categories;
  final List<Poem> allPoems;
  final PoemService poemService;

  const MainScreen({
    super.key,
    required this.categories,
    required this.allPoems,
    required this.poemService,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Reels ekrani boshlang'ich ekran bo'ladi

  // Navigatsiya elementini tanlash
  void _onItemTapped(int index) async {
    // Agar PoemsScreen'ga o'tilsa (index 1), kategoriyalarni qayta yuklash
    if (index == 1) {
      // PoemsScreen'dagi _loadCategories() funksiyasi o'zi yangilaydi.
      // Bu yerda MainScreen'dagi categories final bo'lgani uchun,
      // uni to'g'ridan-to'g'ri o'zgartira olmaymiz.
      // Shuning uchun bu yerda faqat _selectedIndex ni o'zgartirish kifoya.
      // PoemsScreen o'zi didUpdateWidget orqali yangilanishni sezadi.
    }
    setState(() {
      _selectedIndex = index;
    });
    // Agar Reelsga o'tilsa, initialPoemIdNotifier'ni tozalash
    if (index != 2) {
      initialPoemIdNotifier.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // BottomNavigationBar'ning temalarini tanlangan tabga qarab dinamik o'zgartiramiz
    final bool isReelsSelected = _selectedIndex == 2;
    final Color navBarBgColor = isReelsSelected ? Colors.black : Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Colors.white;
    final Color selectedItemColor = isReelsSelected ? Colors.cyanAccent : Theme.of(context).bottomNavigationBarTheme.selectedItemColor ?? Colors.blue;
    final Color unselectedItemColor = isReelsSelected ? Colors.white54 : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Colors.grey;

    final List<Widget> pages = <Widget>[
      SearchScreen(allPoems: widget.allPoems, poemService: widget.poemService),
      PoemsScreen(categories: widget.categories, allPoems: widget.allPoems, poemService: widget.poemService),
      ReelsScreen(allPoems: widget.allPoems, poemService: widget.poemService),
      AIScreen(allPoems: widget.allPoems),
      const AboutScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(navBarBgColor, selectedItemColor, unselectedItemColor),
    );
  }

  // Maxsus pastki navigatsiya paneli
  Widget _buildCustomBottomNavBar(Color bgColor, Color selectedColor, Color unselectedColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor, // Bu yerda 'bgColor' ishlatilgan
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withAlpha((0.2 * 255).round()),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: bgColor, // Bu yerda 'bgColor' ishlatilgan
          selectedItemColor: selectedColor, // Bu yerda 'selectedColor' ishlatilgan
          unselectedItemColor: unselectedColor, // Bu yerda 'unselectedColor' ishlatilgan
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Qidiruv',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'She\'rlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter),
              label: 'Reels',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: 'AI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'About',
            ),
          ],
        ),
      ),
    );
  }
}

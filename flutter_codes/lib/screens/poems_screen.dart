import 'package:abdulhakim_sherlari/utils/iterable_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/category.dart';
import '../models/poem.dart';
import '../services/poem_service.dart';
import '../widgets/neon_border_card.dart';
import 'poem_view_screen.dart';

class PoemsScreen extends StatefulWidget {
  final List<Category> categories;
  final List<Poem> allPoems;
  final PoemService poemService;

  const PoemsScreen({
    super.key,
    required this.categories,
    required this.allPoems,
    required this.poemService,
  });

  @override
  State<PoemsScreen> createState() => _PoemsScreenState();
}

class _PoemsScreenState extends State<PoemsScreen> {
  List<Poem> _selectedCategoryPoems = [];
  String? _selectedCategoryId;
  final ScrollController _poemListScrollController = ScrollController(); // She'rlar ro'yxati uchun alohida controller
  bool _showPoemList = false; // She'rlar ro'yxatini ko'rsatish/yashirish
  List<Category> _currentCategories = []; // Kategoriyalar listini yangilash uchun

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void didUpdateWidget(covariant PoemsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // MainScreen'dan categories yangilanganida, bu yerda ham yangilab olish
    // Lekin MainScreen'dagi categories final bo'lgani uchun, bu faqat
    // MainScreen qayta qurilganda ishlaydi.
    // Asosiy yangilanish PoemService.fetchCategories() ichida bo'ladi.
    _loadCategories();
  }

  // Kategoriyalarni yuklash (sevimlilar bilan birga)
  Future<void> _loadCategories() async {
    final categories = await widget.poemService.fetchCategories();
    setState(() {
      _currentCategories = categories;
      if (_currentCategories.isNotEmpty && _selectedCategoryId == null) {
        _selectedCategoryId = _currentCategories.first.categoryId;
        _selectedCategoryPoems = _currentCategories.first.poems;
      } else if (_selectedCategoryId != null) {
        // Agar tanlangan kategoriya bo'lsa, uni yangilangan ro'yxatdan topib olish
        final selectedCat = _currentCategories.firstWhereOrNull((cat) => cat.categoryId == _selectedCategoryId);
        if (selectedCat != null) {
          _selectedCategoryPoems = selectedCat.poems;
        } else {
          // Agar tanlangan kategoriya topilmasa (masalan, sevimlilar bo'lmasa qolib ketgan bo'lsa)
          // Birinchi kategoriyani tanlash
          _selectedCategoryId = _currentCategories.first.categoryId;
          _selectedCategoryPoems = _currentCategories.first.poems;
          _showPoemList = false; // Kategoriyalar ro'yxatiga qaytish
        }
      }
    });
  }

  @override
  void dispose() {
    _poemListScrollController.dispose();
    super.dispose();
  }

  // Kategoriyani tanlash va she'rlar ro'yxatini ko'rsatish
  void _selectCategoryAndShowPoems(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _selectedCategoryPoems = _currentCategories
          .firstWhere((cat) => cat.categoryId == categoryId)
          .poems;
      _showPoemList = true; // She'rlar ro'yxatini ko'rsatish
      // Ro'yxatni boshiga qaytarish
      if (_poemListScrollController.hasClients) {
        _poemListScrollController.jumpTo(0);
      }
    });
  }

  // Kategoriyalar ekraniga qaytish
  void _backToCategories() {
    setState(() {
      _showPoemList = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showPoemList ? _currentCategories.firstWhere((cat) => cat.categoryId == _selectedCategoryId).categoryName : 'She\'rlar Kategoriyalari'),
        leading: _showPoemList
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _backToCategories,
              )
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _showPoemList
            ? Column(
                key: const ValueKey('poemList'), // Key qo'shildi
                children: [
                  Expanded(
                    child: _selectedCategoryPoems.isEmpty
                        ? const Center(
                            child: Text('Bu kategoriyada she\'rlar yo\'q.', style: TextStyle(color: Colors.black54)),
                          )
                        : ListView.builder(
                            controller: _poemListScrollController,
                            itemCount: _selectedCategoryPoems.length,
                            itemBuilder: (context, index) {
                              final poem = _selectedCategoryPoems[index];
                              return NeonBorderCard(
                                child: ListTile(
                                  leading: Text(poem.poemEmoji, style: const TextStyle(fontSize: 24)),
                                  title: Text(poem.title, style: const TextStyle(color: Colors.black)),
                                  onTap: () {
                                    // Reels ekraniga o'tish o'rniga PoemViewScreen'ga o'tish
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PoemViewScreen(poem: poem, poemService: widget.poemService),
                                    ));
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              )
            : Padding(
                key: const ValueKey('categoriesGrid'), // Key qo'shildi
                padding: const EdgeInsets.all(8.0),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: _currentCategories.length,
                  itemBuilder: (context, index) {
                    final category = _currentCategories[index];
                    final isSelected = _selectedCategoryId == category.categoryId;
                    return GestureDetector(
                      onTap: () => _selectCategoryAndShowPoems(category.categoryId),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.cyan.withAlpha((0.3 * 255).round()) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16.0),
                          border: isSelected
                              ? Border.all(color: Colors.cyanAccent, width: 2)
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.categoryEmoji,
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category.categoryName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${category.poems.length} she\'r',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

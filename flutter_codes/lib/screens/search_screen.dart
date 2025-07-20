import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/poem.dart';
import '../services/poem_service.dart';
import '../widgets/neon_border_card.dart';
import 'poem_view_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Poem> allPoems;
  final PoemService poemService;

  const SearchScreen({super.key, required this.allPoems, required this.poemService});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedCategories = [];
  List<Poem> _filteredPoems = [];
  List<Category> _allCategoriesData = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_performSearch);
    _filteredPoems = List.from(widget.allPoems);
    _loadCategoriesData(); // Kategoriyalarni yuklash
  }

  Future<void> _loadCategoriesData() async {
    try {
      // MainScreen'dan kelgan kategoriyalarni ishlatish
      final categories = await widget.poemService.fetchCategories(); // Bu yerda ham cache'dan oladi
      setState(() {
        _allCategoriesData = categories;
      });
      _performSearch();
    } catch (e) {
      debugPrint('Kategoriyalarni yuklashda xato: $e');
    }
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPoems = widget.allPoems.where((poem) {
        final matchesQuery = poem.title.toLowerCase().contains(query) ||
            (poem.content?.toLowerCase().contains(query) ?? false);
        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.contains(poem.categoryId);
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _toggleCategoryFilter(String categoryId) {
    setState(() {
      if (_selectedCategories.contains(categoryId)) {
        _selectedCategories.remove(categoryId);
      } else {
        _selectedCategories.add(categoryId);
      }
      _performSearch();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qidiruv'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'She\'r nomini, matnini yoki kategoriyasini qidiring...',
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.black54),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch();
                        },
                      )
                    : null,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _allCategoriesData.length,
              itemBuilder: (context, index) {
                final category = _allCategoriesData[index];
                final isSelected = _selectedCategories.contains(category.categoryId);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(category.categoryName),
                    selected: isSelected,
                    onSelected: (selected) {
                      _toggleCategoryFilter(category.categoryId);
                    },
                    backgroundColor: Colors.grey[300],
                    selectedColor: Colors.cyan.withAlpha((0.4 * 255).round()),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                    checkmarkColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _filteredPoems.isEmpty && _searchController.text.isNotEmpty
                ? const Center(
                    child: Text(
                      'Hech qanday she\'r topilmadi.',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredPoems.length,
                    itemBuilder: (context, index) {
                      final poem = _filteredPoems[index];
                      final categoryName = _allCategoriesData.firstWhere(
                        (cat) => cat.categoryId == poem.categoryId,
                        // BU YERDA XATO TO'G'IRLANDI: poemEmoji o'rniga categoryEmoji qo'yildi
                        orElse: () => Category(categoryId: poem.categoryId, categoryName: 'Noma\'lum Kategoriya', categoryEmoji: '❓', poems: []),
                      ).categoryName;

                      return NeonBorderCard(
                        child: ListTile(
                          leading: Text(poem.poemEmoji, style: const TextStyle(fontSize: 24)),
                          title: Text(poem.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                          subtitle: Text(
                            categoryName,
                            style: const TextStyle(color: Colors.black54),
                          ),
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
      ),
    );
  }
}

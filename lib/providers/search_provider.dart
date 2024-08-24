import 'package:flutter/material.dart';
import '../models/poem.dart';

class SearchProvider extends ChangeNotifier {
  List<Poem> _searchResults = [];
  List<Poem> get searchResults => _searchResults;

  void search(String query, List<Category> categories) {
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = categories
          .expand((category) => category.poems)
          .where((poem) =>
      poem.title.toLowerCase().contains(query.toLowerCase()) ||
          poem.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
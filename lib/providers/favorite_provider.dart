import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poem.dart';

class FavoriteProvider with ChangeNotifier {
  List<Poem> _favorites = [];
  List<Poem> get favorites => _favorites;

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    _favorites = favoritesJson.map((e) => Poem.fromJson(json.decode(e))).toList();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favorites.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('favorites', favoritesJson);
  }

  void toggleFavorite(Poem poem) {
    poem.isFavorite = !poem.isFavorite;
    if (poem.isFavorite) {
      _favorites.add(poem);
    } else {
      _favorites.removeWhere((p) => p.title == poem.title && p.text == poem.text);
    }
    _saveFavorites();
    notifyListeners();
  }
}
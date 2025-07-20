import 'package:flutter/material.dart'; // debugPrint uchun
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/poem.dart';

// lib/services/poem_service.dart
// Ma'lumotlarni yuklash xizmati
class PoemService {
  static const String _dataUrl =
      'https://raw.githubusercontent.com/BIOSTEENYC/abdulhakim_sherlari/master/documents/data.json';
  static const String _categoriesKey = 'cached_categories';
  static const String _poemContentPrefix = 'cached_poem_content_';
  static const String _likedPoemsKey = 'liked_poem_ids';
  static const String _lovedCategoryName = 'Sevimlilar ❤️'; // Yangi kategoriya nomi

  // SharedPreferences instanceni olish
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // Kategoriyalarni yuklash (avval cache'dan, keyin internetdan)
  Future<List<Category>> fetchCategories() async {
    final prefs = await _getPrefs();
    final cachedData = prefs.getString(_categoriesKey);
    List<Category> categories = [];

    if (cachedData != null) {
      try {
        List<dynamic> jsonResponse = json.decode(cachedData);
        categories = jsonResponse.map((data) => Category.fromJson(data)).toList();
        debugPrint('Kategoriyalar cache\'dan yuklandi.');
      } catch (e) {
        debugPrint('Cache\'dagi kategoriyalarni o\'qishda xato: $e');
        // Xato bo'lsa, internetdan yuklashga harakat qilish
      }
    }

    if (categories.isEmpty) { // Agar cache'dan yuklanmagan bo'lsa yoki xato bo'lsa
      try {
        final response = await http.get(Uri.parse(_dataUrl));
        if (response.statusCode == 200) {
          final rawJson = utf8.decode(response.bodyBytes);
          prefs.setString(_categoriesKey, rawJson); // Cachega saqlash
          List<dynamic> jsonResponse = json.decode(rawJson);
          categories = jsonResponse.map((data) => Category.fromJson(data)).toList();
          debugPrint('Kategoriyalar internetdan yuklandi va cachega saqlandi.');
        } else {
          throw Exception('Ma\'lumotlar yuklanmadi: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Xato: Ma\'lumotlarni internetdan yuklashda muammo: $e');
        throw Exception('Birinchi marotaba ishga tushirganda internet kerak bo\'ladi. Wi-Fi yoki mobil internetni yoqib qayta uring.');
      }
    }

    // Sevimli she'rlar mavjud bo'lsa, ularni alohida kategoriya qilib qo'shish
    final likedPoemIds = await getLikedPoemIds();
    if (likedPoemIds.isNotEmpty) {
      List<Poem> allPoems = [];
      for (var cat in categories) {
        allPoems.addAll(cat.poems);
      }
      List<Poem> likedPoems = allPoems.where((poem) => likedPoemIds.contains(poem.poemId)).toList();

      if (likedPoems.isNotEmpty) {
        final likedCategory = Category(
          categoryId: 'liked_poems',
          categoryName: _lovedCategoryName,
          categoryEmoji: '❤️',
          poems: likedPoems,
        );
        // Agar allaqachon "Sevimlilar" kategoriyasi bo'lsa, yangilash, aks holda qo'shish
        final existingLikedCategoryIndex = categories.indexWhere((cat) => cat.categoryId == 'liked_poems');
        if (existingLikedCategoryIndex != -1) {
          categories[existingLikedCategoryIndex] = likedCategory;
        } else {
          categories.insert(0, likedCategory); // Eng birinchi qilib qo'shish
        }
      } else {
        // Agar likedPoemIds bo'lsa-yu, lekin likedPoems bo'lmasa, kategoriyani olib tashlash
        categories.removeWhere((cat) => cat.categoryId == 'liked_poems');
      }
    } else {
      // Agar sevimlilar yo'q bo'lsa, kategoriyani olib tashlash
      categories.removeWhere((cat) => cat.categoryId == 'liked_poems');
    }

    return categories;
  }

  // She'r matnini yuklash (avval cache'dan, keyin internetdan)
  Future<String> fetchPoemContent(String fileUrl) async {
    final prefs = await _getPrefs();
    final poemId = fileUrl.split('/').last.split('.').first; // URL dan poemId ni olish
    final cachedContent = prefs.getString('$_poemContentPrefix$poemId');

    if (cachedContent != null) {
      debugPrint('She\'r matni cache\'dan yuklandi: $poemId');
      return cachedContent;
    }

    try {
      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
        final content = utf8.decode(response.bodyBytes);
        prefs.setString('$_poemContentPrefix$poemId', content); // Cachega saqlash
        debugPrint('She\'r matni internetdan yuklandi va cachega saqlandi: $poemId');
        return content;
      } else {
        debugPrint('She\'r matni yuklanmadi: ${response.statusCode} - $fileUrl');
        return '';
      }
    } catch (e) {
      debugPrint('Xato: She\'r matnini internetdan yuklashda muammo: $e - $fileUrl');
      return '';
    }
  }

  // Barcha she'rlar matnini oldindan yuklash va isLiked holatini o'rnatish
  Future<void> preloadAllPoemContents(List<Poem> poems) async {
    final likedPoemIds = await getLikedPoemIds();
    for (var poem in poems) {
      poem.isLiked = likedPoemIds.contains(poem.poemId); // isLiked holatini o'rnatish
      if (poem.content == null || poem.content!.isEmpty) {
        poem.content = await fetchPoemContent(poem.file);
      }
    }
  }

  // Sevimlilar holatini saqlash
  Future<void> saveLikedPoemIds(Set<String> likedPoemIds) async {
    final prefs = await _getPrefs();
    prefs.setStringList(_likedPoemsKey, likedPoemIds.toList());
    debugPrint('Sevimlilar saqlandi: ${likedPoemIds.length} ta');
  }

  // Sevimlilar holatini yuklash
  Future<Set<String>> getLikedPoemIds() async {
    final prefs = await _getPrefs();
    final likedList = prefs.getStringList(_likedPoemsKey) ?? [];
    debugPrint('Sevimlilar yuklandi: ${likedList.length} ta');
    return likedList.toSet();
  }
}

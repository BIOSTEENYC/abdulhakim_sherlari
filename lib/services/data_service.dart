import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/poem.dart';

class DataService {
  Future<List<Category>> getCategories() async {
    final String response = await rootBundle.loadString('assets/sherlar.json');
    final data = await json.decode(response) as Map<String, dynamic>;
    return (data['categories'] as List<dynamic>)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
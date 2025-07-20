// Ma'lumotlar modellari
import 'package:abdulhakim_sherlari/models/poem.dart';

class Category {
  final String categoryId;
  final String categoryName;
  final String categoryEmoji;
  final List<Poem> poems;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryEmoji,
    required this.poems,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var poemsList = json['poems'] as List;
    List<Poem> poems = poemsList.map((i) => Poem.fromJson(i)).toList();
    return Category(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryEmoji: json['category_emoji'],
      poems: poems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'category_emoji': categoryEmoji,
      'poems': poems.map((p) => p.toJson()).toList(),
    };
  }
}

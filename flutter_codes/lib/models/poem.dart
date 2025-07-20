class Poem {
  final String poemId;
  final String title;
  final String file;
  final String poemEmoji;
  final String categoryId;
  String? content; // She'r matni keyinchalik yuklanadi
  bool isLiked; // Sevimlilar uchun yangi maydon

  Poem({
    required this.poemId,
    required this.title,
    required this.file,
    required this.poemEmoji,
    required this.categoryId,
    this.content,
    this.isLiked = false, // Boshlang'ich holati false
  });

  factory Poem.fromJson(Map<String, dynamic> json) {
    return Poem(
      poemId: json['poem_id'],
      title: json['title'],
      file: json['file'],
      poemEmoji: json['poem_emoji'],
      categoryId: json['category_id'],
      isLiked: json['isLiked'] ?? false, // JSONdan yuklashda isLiked ni ham olish
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poem_id': poemId,
      'title': title,
      'file': file,
      'poem_emoji': poemEmoji,
      'category_id': categoryId,
      'content': content,
      'isLiked': isLiked,
    };
  }
}

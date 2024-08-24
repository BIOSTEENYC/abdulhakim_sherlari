class Poem {
  final String title;
  final String text;
  bool isFavorite;

  Poem({required this.title, required this.text, this.isFavorite = false});

  factory Poem.fromJson(Map<String, dynamic> json) {
    return Poem(
      title: json['title'] as String,
      text: json['text'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'isFavorite': isFavorite,
    };
  }
}



class Category {
  final String name;
  final List<Poem> poems;

  const Category({required this.name, required this.poems});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      poems: (json['poems'] as List<dynamic>)
          .map((e) => Poem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
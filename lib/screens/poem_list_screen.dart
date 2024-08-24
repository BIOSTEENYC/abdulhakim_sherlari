import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../widgets/poem_card.dart';

class PoemListScreen extends StatelessWidget {
  final Category category;

  const PoemListScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: category.poems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final poem = category.poems[index];
          return PoemCard(poem: poem);
        },
      ),
    );
  }
}
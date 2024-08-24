import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../screens/poem_screen.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;

  const PoemCard({Key? key, required this.poem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          poem.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          poem.text.split('\n').first,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoemScreen(poem: poem),
            ),
          );
        },
      ),
    );
  }
}
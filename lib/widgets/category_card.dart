import 'package:flutter/material.dart';
import '../models/poem.dart';
import '../screens/poem_list_screen.dart';
import '../styles.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoemListScreen(category: category),
            ),
          );
        },
        child: Container(
    decoration: BoxDecoration(
    gradient: AppStyles.secondaryGradient(context),
    borderRadius: BorderRadius.circular(16),
    ),
          child: Center(
            child: Text(
              category.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}
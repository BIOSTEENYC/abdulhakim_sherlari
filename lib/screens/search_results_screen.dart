import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart';
import '../services/data_service.dart';
import '../widgets/poem_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataService().getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Xato yuz berdi: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Ma\'lumotlar topilmadi'));
        } else {
          context.read<SearchProvider>().search(query, snapshot.data!);
          return Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              if (searchProvider.searchResults.isEmpty) {
                return const Center(child: Text('She\'rlar topilmadi'));
              }
              return ListView.builder(
                itemCount: searchProvider.searchResults.length,
                itemBuilder: (context, index) {
                  return PoemCard(poem: searchProvider.searchResults[index]);
                },
              );
            },
          );
        }
      },
    );
  }
}
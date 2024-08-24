import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/poem.dart';
import '../providers/search_provider.dart';
import '../screens/poem_screen.dart';

class CustomSearchBar extends StatefulWidget {
  final List<Category> categories;

  const CustomSearchBar({super.key, required this.categories});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showResults = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(28),
          ),
          child: TextField(
            controller: _controller,
            onChanged: (query) {
              context.read<SearchProvider>().search(query, widget.categories);
              setState(() {
                _showResults = query.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: 'She\'rlarni qidiring',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  context.read<SearchProvider>().search('', widget.categories);
                  setState(() {
                    _showResults = false;
                  });
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        if (_showResults) _buildSearchResults(),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.searchResults.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('She\'rlar topilmadi'),
          );
        }
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3, // Ekran balandligining 30%
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: searchProvider.searchResults.length,
            itemBuilder: (context, index) {
              final poem = searchProvider.searchResults[index];
              return ListTile(
                title: Text(poem.title),
                subtitle: Text(
                  poem.text.split('\n').first,
                  maxLines: 1,
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
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
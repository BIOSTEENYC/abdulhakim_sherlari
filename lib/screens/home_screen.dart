import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/poem.dart';
import '../services/data_service.dart';
import '../widgets/category_card.dart';
import '../widgets/search_bar.dart';
import '../providers/favorite_provider.dart';
import '../providers/theme_provider.dart';
import 'poem_screen.dart';
import 'author_bio_screen.dart';
import 'text_settings_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: true,
              title: const Text('Abdulhakim Sherlar'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthorBioScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Provider.of<ThemeProvider>(context).isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.text_fields),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TextSettingsScreen()),
                    );
                  },
                ),
              ],
              bottom: TabBar(
                tabs: const [
                  Tab(text: 'Kategoriyalar'),
                  Tab(text: 'Sevimlilar'),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<List<Category>>(
                  future: DataService().getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Xato yuz berdi: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Ma\'lumotlar topilmadi'));
                    } else {
                      return CustomSearchBar(categories: snapshot.data!);
                    }
                  },
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  _buildCategoriesTab(),
                  _buildFavoritesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return FutureBuilder<List<Category>>(
      future: DataService().getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Xato yuz berdi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Ma\'lumotlar topilmadi'));
        } else {
          return LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = constraints.maxWidth > 600 ? 200 : constraints.maxWidth / 2 - 24;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                  childAspectRatio: itemWidth / (itemWidth * 0.75),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final category = snapshot.data![index];
                  return CategoryCard(category: category);
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildFavoritesTab() {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        if (favoriteProvider.favorites.isEmpty) {
          return const Center(child: Text('Sevimli she\'rlar yo\'q'));
        }
        return ListView.builder(
          itemCount: favoriteProvider.favorites.length,
          itemBuilder: (context, index) {
            final poem = favoriteProvider.favorites[index];
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
        );
      },
    );
  }
}
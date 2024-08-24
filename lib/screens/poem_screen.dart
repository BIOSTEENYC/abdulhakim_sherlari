import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/poem.dart';
import '../providers/favorite_provider.dart';
import '../providers/text_settings_provider.dart';

class PoemScreen extends StatelessWidget {
  final Poem poem;

  const PoemScreen({Key? key, required this.poem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textSettings = Provider.of<TextSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(poem.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _sharePoem(context);
            },
          ),
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              return IconButton(
                icon: Icon(
                  poem.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: poem.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  favoriteProvider.toggleFavorite(poem);
                },
              );
            },
          ),
        ],
      ),
      body: Center( // Markazga joylashtirish uchun
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 600, // Maksimal kenglikni cheklash
            ),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  poem.text,
                  style: TextStyle(
                    fontSize: textSettings.fontSize,
                    fontFamily: textSettings.fontFamily,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center, // Matnni markazga joylashtirish
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateFontSize(double screenWidth) {
    // Ekran kengligiga qarab shrift o'lchamini hisoblash
    if (screenWidth > 600) {
      return 20.0; // Katta ekranlar uchun
    } else if (screenWidth > 400) {
      return 18.0; // O'rta o'lchamli ekranlar uchun
    } else {
      return 16.0; // Kichik ekranlar uchun
    }
  }

  Future<void> _sharePoem(BuildContext context) async {
    final String shareText = '${poem.title}\n\n${poem.text}\n\n---Abdulhakim she\'rlari---\nhttps://t.me/Biosteenyc';
    try {
      await Share.share(shareText);
      print('Share completed');
    } catch (e) {
      print('Error sharing: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ulashishda xatolik yuz berdi: $e')),
      );
    }
  }}

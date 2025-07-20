import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Havola ochilmadi: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ilova Haqida'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.cyanAccent.withAlpha((0.2 * 255).round()),
                    backgroundImage: const AssetImage('assets/abdulhakim_avatar.png'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Abdulhakim She\'rlari',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Text(
                    'Biosteenyc | Abdulhakim Xayitboyev tomonidan yaratilgan',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Text(
              'Ilova Maqsadi:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'Bu ilova Abdulhakimning she\'rlarini zamonaviy va interaktiv tarzda taqdim etish uchun yaratilgan. Foydalanuvchilar she\'rlarni qidirish, kategoriyalar bo\'yicha ko\'rish, "Reels" formatida tomosha qilish va hatto she\'rlar bilan "chat" qilish imkoniyatiga ega.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            Text(
              'Xususiyatlar:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('GitHubdan ma\'lumotlarni yuklash'),
            _buildFeatureItem('Neon animatsiyali UI elementlar'),
            _buildFeatureItem('Interaktiv "Reels" she\'r ko\'rinishi'),
            _buildFeatureItem('She\'r matnidagi harflar uchun dinamik gradient effektlar'),
            _buildFeatureItem('AI ilhomlangan chat rejimi (she\'r satrlarini avto-yozish)'),
            _buildFeatureItem('Real-time matn qidiruvi'),
            _buildFeatureItem('Ulashish'),
            const SizedBox(height: 24),
            Text(
              'Aloqa:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            _buildLinkButton('GitHub', 'https://github.com/BIOSTEENYC'),
            _buildLinkButton('Telegram', 'https://t.me/biosteenyc'),
            _buildLinkButton('Biosteenyc sayti', 'https://biosteenyc.github.io'),
            const SizedBox(height: 24),

            // --- Yangi Motivatsiya bo'limi ---
            Text(
              'Motivatsiya bering:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0), // Rasmga burchak yumaloqligi
                    child: Image.network(
                      'https://raw.githubusercontent.com/BIOSTEENYC/ustamakon/main/motivatsiya.png', 
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Dasturlash va She\'riyat rivoji uchun!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // --- Motivatsiya bo'limi tugadi ---

            Center(
              child: Text(
                'Versiya: 2.0.0\n© 2025-2026 Biosteenyc | Abdulhakim Xayitboyev. Barcha huquqlar himoyalangan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton.icon(
        onPressed: () => _launchURL(url),
        icon: const Icon(Icons.link, color: Colors.black),
        label: Text(text, style: const TextStyle(color: Colors.black)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyanAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
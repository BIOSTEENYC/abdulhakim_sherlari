import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorBioScreen extends StatelessWidget {
  const AuthorBioScreen({Key? key}) : super(key: key);

  Future<void> _launchYouTube() async {
    final Uri url = Uri.parse('https://www.youtube.com/@Biosteenyc');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muallif haqida'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/author_photo.jpg'), // Rasmni assets papkasiga qo'shing
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Abdulhakim al - Biosteenyc',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Tug\'ilgan sana: 2004-yil 6 - iyul', // Haqiqiy ma'lumotlarni kiriting
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Abdulhakim zamonaviy o\'zbek she\'riyatining yosh va iste\'dodli havaskor shoirlaridan biri. U o\'zining chuqur ma\'noli, his-tuyg\'ularga boy she\'rlari bilan ko\'plab kitobxonlar qalbidan joy olgan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Asosiy mavzular: Ota-ona, Ustoz, Dasturlash va IT, Sevgi',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Abdulhakim she\'rlarida zamonaviy texnologiyalar va an\'anaviy qadriyatlarni uyg\'unlashtirish g\'oyasi ko\'zga tashlanadi. Uning asarlari yoshlar orasida katta qiziqish uyg\'otgan va ijtimoiy tarmoqlarda keng tarqalgan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('YouTube kanalga obuna bo\'ling'),
              onPressed: _launchYouTube,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red,
              ),
            ),
            // Boshqa biografik ma'lumotlarni qo'shing
          ],
        ),
      ),
    );
  }
}
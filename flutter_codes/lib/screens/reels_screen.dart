import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/poem.dart';
import '../services/poem_service.dart';
import '../utils/notifiers.dart';
import '../widgets/poem_chat_animator.dart';

class ReelsScreen extends StatefulWidget {
  final List<Poem> allPoems;
  final PoemService poemService;

  const ReelsScreen({
    super.key,
    required this.allPoems,
    required this.poemService,
  });

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  List<Poem> _reelsPoems = [];
  Set<String> _likedPoemIds = {}; // Sevimlilar IDlarini saqlash

  @override
  void initState() {
    super.initState();
    _reelsPoems = List.from(widget.allPoems); // Barcha she'rlarni nusxalash
    _loadLikedStatus(); // Sevimlilar holatini yuklash

    // initialPoemIdNotifier'dan kelgan she'rni birinchi o'ringa qo'yish
    Poem? targetPoem;
    if (initialPoemIdNotifier.value != null) {
      final foundIndex = _reelsPoems.indexWhere((p) => p.poemId == initialPoemIdNotifier.value);
      if (foundIndex != -1) {
        targetPoem = _reelsPoems.removeAt(foundIndex);
      }
      // Notifier'ni ishlatilgandan keyin tozalash
      WidgetsBinding.instance.addPostFrameCallback((_) {
        initialPoemIdNotifier.value = null;
      });
    }

    _reelsPoems.shuffle(); // Qolgan she'rlarni aralashtirish
    if (targetPoem != null) {
      _reelsPoems.insert(0, targetPoem); // Maqsadli she'rni boshiga qo'yish
    }

    _pageController = PageController(initialPage: 0); // Har doim 0 dan boshlash
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPageIndex) {
        setState(() {
          _currentPageIndex = _pageController.page!.round();
        });
      }
    });
    if (_reelsPoems.isNotEmpty) {
      _loadPoemContent(_reelsPoems[_currentPageIndex]);
    }
  }

  // Sevimlilar holatini yuklash
  Future<void> _loadLikedStatus() async {
    _likedPoemIds = await widget.poemService.getLikedPoemIds();
    setState(() {
      // UI ni yangilash uchun
    });
  }

  Future<void> _loadPoemContent(Poem poem) async {
    if (poem.content == null || poem.content!.isEmpty) {
      final content = await widget.poemService.fetchPoemContent(poem.file);
      setState(() {
        poem.content = content;
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _loadPoemContent(_reelsPoems[index]);
  }

  // Like tugmasini bosish funksiyasi
  void _toggleLike(Poem poem) async {
    setState(() {
      if (_likedPoemIds.contains(poem.poemId)) {
        _likedPoemIds.remove(poem.poemId);
        poem.isLiked = false;
      } else {
        _likedPoemIds.add(poem.poemId);
        poem.isLiked = true;
      }
    });
    await widget.poemService.saveLikedPoemIds(_likedPoemIds); // Sevimlilarni saqlash
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reels'),
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: _reelsPoems.isEmpty
            ? const Center(
                child: Text('Yuklanadigan she\'rlar yo\'q.', style: TextStyle(color: Colors.white70)),
              )
            : PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: _reelsPoems.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final poem = _reelsPoems[index];
                  final ScreenshotController reelScreenshotController = ScreenshotController();
                  return _buildPoemCard(poem, reelScreenshotController);
                },
              ),
      ),
    );
  }

  Widget _buildPoemCard(Poem poem, ScreenshotController controller) {
    return Screenshot(
      controller: controller,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade900,
              Colors.black,
              Colors.blueGrey.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withAlpha((0.1 * 255).round()),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        margin: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        poem.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.cyanAccent,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded( // PoemChatAnimator Expanded ichiga olindi
                        child: poem.content == null
                            ? const Center(child: CupertinoActivityIndicator(color: Colors.cyanAccent)) // Yuklanish indikatori
                            : PoemChatAnimator(
                                poemContent: poem.content!,
                                parentPageController: _pageController, // PageController'ni pastga uzatish
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  children: [
                    _buildIconButton(
                      poem.isLiked ? Icons.favorite : Icons.favorite_border, // Like holatiga qarab ikonka
                      'Like',
                      () => _toggleLike(poem), // Like funksiyasi
                      color: poem.isLiked ? Colors.redAccent : Colors.white, // Like holatiga qarab rang
                    ),
                    const SizedBox(height: 10),
                    _buildIconButton(Icons.comment, 'Comment', () {
                      _launchURL('https://t.me/biosteenyc'); // Telegramga o'tish
                    }),
                    const SizedBox(height: 10),
                    _buildIconButton(Icons.share, 'Share', () => _shareApp()), // Appni ulashish
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ilovani ulashish funksiyasi
  Future<void> _shareApp() async {
    const String appLink = 'https://play.google.com/store/apps/details?id=uz.biosteenyc.abdulhakim_sherlari&hl=uz_SV';
    await SharePlus.instance.share(ShareParams(text: 'Abdulhakim she\'rlarining go\'zal olamiga sayohat qiling! Ilovani yuklab oling:\n$appLink'));
  }

  // Yangi _launchURL funksiyasi
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Havola ochilmadi: $url');
    }
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed, {Color color = Colors.white}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.1 * 255).round()),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withAlpha((0.3 * 255).round()),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: color, size: 28), // Rangni parametr orqali olish
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  // _showCommentModal funksiyasi olib tashlandi, chunki u ishlatilmaydi.
}

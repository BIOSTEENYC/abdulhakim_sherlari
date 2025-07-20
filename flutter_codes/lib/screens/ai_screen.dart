import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/poem.dart';

class AIScreen extends StatefulWidget {
  final List<Poem> allPoems;

  const AIScreen({super.key, required this.allPoems});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final TextEditingController _inputController = TextEditingController();
  final List<String> _chatHistory = [];
  Timer? _typingTimer;
  int _currentCharIndex = 0;
  final ScrollController _aiChatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatHistory.add('Matn kiriting...');
    _inputController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    // Agar foydalanuvchi space bosgan bo'lsa
    if (_inputController.text.isNotEmpty && _inputController.text.endsWith(' ')) {
      _stopTypingAnimation(); // Oldingi animatsiyani to'xtatish
      final query = _inputController.text.trim();
      // Matnni tozalash AI javobini boshlashdan oldin
      _inputController.clear();
      _generatePoemLine(query);
    } else if (_inputController.text.isEmpty) {
      // Agar matn o'chirilgan bo'lsa, animatsiyani to'xtatish
      _stopTypingAnimation();
    }
  }

  void _generatePoemLine(String query) {
    if (query.isEmpty) {
      _stopTypingAnimation();
      setState(() {
        _chatHistory.add('Matn kiriting...');
      });
      _scrollToBottom();
      return;
    }

    String foundLine = ''; // Javob matni
    bool found = false;
    for (var poem in widget.allPoems) {
      if (poem.content != null) {
        final lines = poem.content!.split('\n').where((line) => line.trim().isNotEmpty).toList();
        for (var line in lines) {
          if (line.toLowerCase().contains(query.toLowerCase())) {
            foundLine = line;
            found = true;
            break;
          }
        }
      }
      if (found) break;
    }

    if (!found && widget.allPoems.isNotEmpty) {
      // Tasodifiy she'r satrini olish
      final random = Random();
      final randomPoem = widget.allPoems[random.nextInt(widget.allPoems.length)];
      if (randomPoem.content != null && randomPoem.content!.isNotEmpty) {
        final lines = randomPoem.content!.split('\n').where((line) => line.trim().isNotEmpty).toList();
        if (lines.isNotEmpty) {
          foundLine = lines[random.nextInt(lines.length)]; // Faqat tasodifiy satr
        } else {
          foundLine = 'Hech qanday she\'r satri topilmadi.';
        }
      } else {
        foundLine = 'Hech qanday she\'r satri topilmadi.';
      }
    } else if (!found) {
       foundLine = 'Hech qanday she\'r satri topilmadi.';
    }


    _startTypingAnimation(foundLine);
  }

  void _startTypingAnimation(String textToType) {
    _stopTypingAnimation();
    _currentCharIndex = 0;
    _chatHistory.add('');

    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentCharIndex < textToType.length) {
        setState(() {
          _chatHistory[_chatHistory.length - 1] = textToType.substring(0, _currentCharIndex + 1);
        });
        _scrollToBottom();
        _currentCharIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  void _stopTypingAnimation() {
    _typingTimer?.cancel();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_aiChatScrollController.hasClients) {
        _aiChatScrollController.animateTo(
          _aiChatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _typingTimer?.cancel();
    _aiChatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Oynasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _aiChatScrollController,
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        _chatHistory[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: 'She\'r yaratish uchun matn kiriting...',
                prefixIcon: const Icon(Icons.edit, color: Colors.black54),
              ),
              style: const TextStyle(color: Colors.black),
              onSubmitted: (value) {
                if (!value.endsWith(' ')) { // Faqat space bosilmagan bo'lsa
                  _generatePoemLine(value);
                  _inputController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

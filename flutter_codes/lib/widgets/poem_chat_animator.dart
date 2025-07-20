import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/chat_message.dart';
import 'floating_mini_keyboard.dart';

// Reels ichidagi chat animatsiyasi
class PoemChatAnimator extends StatefulWidget {
  final String poemContent;
  final PageController parentPageController; // PageController'ni qabul qilish

  const PoemChatAnimator({super.key, required this.poemContent, required this.parentPageController});

  @override
  State<PoemChatAnimator> createState() => _PoemChatAnimatorState();
}

class _PoemChatAnimatorState extends State<PoemChatAnimator> {
  final List<List<String>> _stanzas = []; // 'final' qilib o'zgartirildi
  final List<ChatMessage> _chatMessages = [];
  Timer? _typingTimer;
  int _currentStanzaIndex = 0;
  int _currentCharIndex = 0;
  bool _isBiosteenycTyping = true;
  final ScrollController _chatScrollController = ScrollController();
  final ValueNotifier<String?> _currentTypedCharNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _splitPoemIntoStanzas();
    _startTypingAnimation();
  }

  @override
  void didUpdateWidget(covariant PoemChatAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.poemContent != widget.poemContent) {
      _typingTimer?.cancel();
      _chatMessages.clear();
      _currentStanzaIndex = 0;
      _currentCharIndex = 0;
      _isBiosteenycTyping = true;
      _stanzas.clear(); // `final` bo'lgani uchun `_stanzas`ni tozalash kerak
      _splitPoemIntoStanzas();
      _startTypingAnimation();
    }
  }

  void _splitPoemIntoStanzas() {
    final List<String> lines = widget.poemContent.split('\n').where((line) => line.trim().isNotEmpty).toList();
    _stanzas.clear();
    for (int i = 0; i < lines.length; i += 4) {
      _stanzas.add(lines.sublist(i, min(i + 4, lines.length)));
    }
  }

  void _startTypingAnimation() {
    if (_stanzas.isEmpty) return;

    _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_currentStanzaIndex >= _stanzas.length) {
        timer.cancel();
        _currentTypedCharNotifier.value = null;
        return;
      }

      final currentStanza = _stanzas[_currentStanzaIndex].join('\n');
      if (_currentCharIndex < currentStanza.length) {
        setState(() {
          if (_chatMessages.isEmpty || _chatMessages.last.isBiosteenyc != _isBiosteenycTyping || _chatMessages.last.isComplete) {
            _chatMessages.add(ChatMessage(
              text: '',
              isBiosteenyc: _isBiosteenycTyping,
              typingProgress: 0.0,
              isComplete: false,
            ));
          }
          final currentMessage = _chatMessages.last;
          currentMessage.text = currentStanza.substring(0, _currentCharIndex + 1);
          currentMessage.typingProgress = (_currentCharIndex + 1) / currentStanza.length;
        });
        _currentTypedCharNotifier.value = currentStanza[_currentCharIndex];
        // Chatni avtomatik pastga scroll qilish
        if (_chatScrollController.hasClients) {
          _chatScrollController.jumpTo(_chatScrollController.position.maxScrollExtent);
        }
        _currentCharIndex++;
      } else {
        setState(() {
          _chatMessages.last.isComplete = true;
          _isBiosteenycTyping = !_isBiosteenycTyping;
          _currentStanzaIndex++;
          _currentCharIndex = 0;
        });
        _currentTypedCharNotifier.value = null;
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _chatScrollController.dispose();
    _currentTypedCharNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is OverscrollNotification) {
                if (notification.overscroll < 0 && notification.metrics.pixels == notification.metrics.minScrollExtent) {
                  // Yuqoriga overscroll bo'lsa va eng yuqorida bo'lsa, oldingi reelga o'tish
                  if (widget.parentPageController.hasClients && widget.parentPageController.page! > 0) {
                    widget.parentPageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    return true; // Notificationni iste'mol qilish
                  }
                } else if (notification.overscroll > 0 && notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                  // Pastga overscroll bo'lsa va eng pastda bo'lsa, keyingi reelga o'tish
                  if (widget.parentPageController.hasClients && widget.parentPageController.page! < widget.parentPageController.position.maxScrollExtent) {
                    widget.parentPageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                    return true; // Notificationni iste'mol qilish
                  }
                }
              }
              return false; // Boshqa notificationlarni o'tkazib yuborish
            },
            child: ListView.builder(
              controller: _chatScrollController,
              shrinkWrap: true,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final message = _chatMessages[index];
                return _buildChatBubble(message);
              },
            ),
          ),
        ),
        if (!_isBiosteenycTyping && _chatMessages.isNotEmpty && !_chatMessages.last.isBiosteenyc)
          Align(
            alignment: Alignment.centerRight,
            child: FloatingMiniKeyboard(currentTypedChar: _currentTypedCharNotifier),
          ),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isBiosteenyc ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.isBiosteenyc ? Colors.blueAccent.withAlpha((0.3 * 255).round()) : Colors.greenAccent.withAlpha((0.3 * 255).round()),
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.cyanAccent.withAlpha(((message.typingProgress * 255).round()).clamp(0, 255)),
            width: 2.0,
          ),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

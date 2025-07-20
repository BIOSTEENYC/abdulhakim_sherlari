import 'dart:async';

import 'package:flutter/material.dart';

class FloatingMiniKeyboard extends StatefulWidget {
  final ValueNotifier<String?> currentTypedChar;

  const FloatingMiniKeyboard({super.key, required this.currentTypedChar});

  @override
  State<FloatingMiniKeyboard> createState() => _FloatingMiniKeyboardState();
}

class _FloatingMiniKeyboardState extends State<FloatingMiniKeyboard> {
  String? _highlightedChar;
  Timer? _highlightTimer;

  @override
  void initState() {
    super.initState();
    widget.currentTypedChar.addListener(_onCharTyped);
  }

  void _onCharTyped() {
    setState(() {
      _highlightedChar = widget.currentTypedChar.value?.toUpperCase();
      if (_highlightedChar == ' ') {
        _highlightedChar = 'Space';
      }
    });
    _highlightTimer?.cancel();
    if (_highlightedChar != null) {
      _highlightTimer = Timer(const Duration(milliseconds: 150), () {
        setState(() {
          _highlightedChar = null;
        });
      });
    }
  }

  @override
  void dispose() {
    widget.currentTypedChar.removeListener(_onCharTyped);
    _highlightTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<List<String>> keyboardRows = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];

    return Container(
      margin: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withAlpha((0.2 * 255).round()),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var row in keyboardRows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.map((char) {
                  final isHighlighted = _highlightedChar == char;
                  return Expanded( // Kengayish uchun Expanded qo'shildi
                    child: _buildKeyContent(char, isHighlighted),
                  );
                }).toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                Expanded( // Space tugmasi ham kengayishi uchun Expanded qo'shildi
                  child: _buildKeyContent('Space', _highlightedChar == 'Space'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tugma kontentini yaratuvchi yordamchi funksiya
  Widget _buildKeyContent(String char, bool isHighlighted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      height: 35, // Balandlik saqlanadi
      margin: const EdgeInsets.symmetric(horizontal: 2.0), // Tugmalar orasidagi bo'shliq
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.cyanAccent : Colors.grey[700],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.cyanAccent.withAlpha((0.3 * 255).round())),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.cyanAccent.withAlpha((0.5 * 255).round()),
                  blurRadius: 8,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: TextStyle(
          color: isHighlighted ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

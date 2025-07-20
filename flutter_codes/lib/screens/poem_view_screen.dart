import 'package:flutter/material.dart';

import '../models/poem.dart';
import '../services/poem_service.dart';

class PoemViewScreen extends StatefulWidget {
  final Poem poem;
  final PoemService poemService;

  const PoemViewScreen({super.key, required this.poem, required this.poemService});

  @override
  State<PoemViewScreen> createState() => _PoemViewScreenState();
}

class _PoemViewScreenState extends State<PoemViewScreen> {
  String _poemContent = 'Yuklanmoqda...';

  @override
  void initState() {
    super.initState();
    _loadPoemContent();
  }

  Future<void> _loadPoemContent() async {
    if (widget.poem.content != null && widget.poem.content!.isNotEmpty) {
      setState(() {
        _poemContent = widget.poem.content!;
      });
    } else {
      final content = await widget.poemService.fetchPoemContent(widget.poem.file);
      setState(() {
        _poemContent = content.isNotEmpty ? content : 'She\'r matni topilmadi.';
        widget.poem.content = _poemContent; // Yuklangan matnni Poem obyektiga saqlash
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poem.title),
      ),
      body: Center( // Matnni markazga joylashtirish uchun Center widgeti qo'shildi
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Matnni markazga joylashtirish
            children: [
              Text(
                _poemContent,
                textAlign: TextAlign.center, // Matnni markazga tekislash
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

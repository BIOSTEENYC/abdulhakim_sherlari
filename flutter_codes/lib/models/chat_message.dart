class ChatMessage {
  String text;
  final bool isBiosteenyc;
  double typingProgress;
  bool isComplete;

  ChatMessage({
    required this.text,
    required this.isBiosteenyc,
    required this.typingProgress,
    this.isComplete = false,
  });
}

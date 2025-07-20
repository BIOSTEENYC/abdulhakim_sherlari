import 'package:flutter/material.dart';

class NeonBorderCard extends StatefulWidget {
  final Widget child;
  const NeonBorderCard({super.key, required this.child});

  @override
  State<NeonBorderCard> createState() => _NeonBorderCardState();
}

class _NeonBorderCardState extends State<NeonBorderCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [
                Colors.cyanAccent.withAlpha((0.6 * _animation.value * 255).round().clamp(0, 255)),
                Colors.purpleAccent.withAlpha((0.6 * (1 - _animation.value) * 255).round().clamp(0, 255)),
                Colors.pinkAccent.withAlpha((0.6 * _animation.value * 255).round().clamp(0, 255)),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withAlpha(((0.2 + 0.3 * _animation.value) * 255).round().clamp(0, 255)),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

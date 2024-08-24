import 'package:flutter/material.dart';

class AppStyles {
  static Gradient primaryGradient(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LinearGradient(
      colors: isDarkMode
          ? [colorScheme.primary, colorScheme.secondary]
          : [colorScheme.primary.withOpacity(0.7), colorScheme.secondary.withOpacity(0.7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static Gradient secondaryGradient(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LinearGradient(
      colors: isDarkMode
          ? [colorScheme.secondary, colorScheme.tertiary]
          : [colorScheme.secondary.withOpacity(0.6), colorScheme.tertiary.withOpacity(0.6)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static Gradient backgroundGradient(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return LinearGradient(
      colors: isDarkMode
          ? [
        colorScheme.background,
        colorScheme.background.withOpacity(0.8),
        colorScheme.surface,
      ]
          : [
        colorScheme.background,
        colorScheme.background.withOpacity(0.3),
        colorScheme.surface.withOpacity(0.1),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  static TextStyle headerTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      color: colorScheme.onBackground,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle bodyTextStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextStyle(
      color: colorScheme.onBackground,
      fontSize: 16,
    );
  }
}
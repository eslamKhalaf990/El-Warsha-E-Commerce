import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand Colors
  static const Color burgundy = Color(0xFF6D1A2E);
  static const Color deepWine = Color(0xFF4A0F1E);
  static const Color blush = Color(0xFFF7EBEC);
  static const Color ivory = Color(0xFFFFFAF6);
  static const Color champagne = Color(0xFFC9A66B);
  static const Color ink = Color(0xFF2B1A1E);
  static const Color muted = Color(0xFF8A737A);
  static const Color line = Color(0xFFEADDD9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;
}

abstract final class AppStatusColors {
  // Status: In Progress
  static const Color inProgressText = Color(0xFF7A5A1C);
  static const Color inProgressBackground = Color(0xFFF3E5C8);

  // Status: Success / Delivered
  static const Color successText = Color(0xFF2F6A44);
  static const Color successBackground = Color(0xFFDCEBE0);

  // Status: Neutral / Cancelled
  static const Color neutralText = Color(0xFF777777);
  static const Color neutralBackground = Color(0xFFEEEEEE);

  // Status: Error
  static const Color errorText = Color(0xFFB3261E);
  static const Color errorBackground = Color(0xFFFCE8E6);
}

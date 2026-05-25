import 'package:flutter/material.dart';

/// Palet warna terpusat. Aksen utama hijau, konsisten dengan brand existing.
/// Ubah di sini → berubah di seluruh app.
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF43A047);
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primarySoft = Color(0xFFE8F5E9);

  static const Color background = Colors.white;
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);

  static const Color border = Color(0xFFE0E0E0);
  static const Color fieldFill = Color(0xFFF5F5F5);

  static const Color error = Color(0xFFE53935);
  static const Color star = Color(0xFFFFA726);

  /// Shadow lembut untuk kartu.
  static final Color shadow = Colors.black.withValues(alpha: 0.05);
}

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Tema aplikasi terpusat (light, aksen hijau, Material 3).
/// Sengaja konservatif agar tidak mengubah tampilan screen yang belum dimigrasi.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.seed);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      // Snackbar modern: melayang + sudut membulat. Warna dibiarkan default
      // agar snackbar error (yang tak menyetel warna) tidak menjadi hijau.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}

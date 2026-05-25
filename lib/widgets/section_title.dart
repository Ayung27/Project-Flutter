import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Judul seksi yang konsisten (mis. "Ringkasan Pesanan", "Metode Pembayaran").
class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

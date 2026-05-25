import 'package:flutter/material.dart';
import '../models/order_status.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Chip status pesanan: ikon + label, warna soft sesuai status.
/// Pemetaan warna/ikon (urusan UI) sengaja terpisah dari model.
class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _style(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            status.label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _style(OrderStatus status) {
    switch (status) {
      case OrderStatus.diproses:
        return (const Color(0xFFFB8C00), Icons.receipt_long);
      case OrderStatus.disiapkan:
        return (const Color(0xFF1E88E5), Icons.restaurant);
      case OrderStatus.dikirim:
        return (const Color(0xFF00897B), Icons.delivery_dining);
      case OrderStatus.selesai:
        return (AppColors.primary, Icons.check_circle);
      case OrderStatus.dibatalkan:
        return (AppColors.error, Icons.cancel);
    }
  }
}

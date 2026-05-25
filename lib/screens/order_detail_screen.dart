import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../providers/cart_providers.dart';
import '../data/menu_data.dart';
import '../utils/currency.dart';
import '../utils/reorder.dart';
import '../utils/delivery.dart';
import '../widgets/order_status_badge.dart';
import '../widgets/section_title.dart';
import '../widgets/app_card.dart';
import '../widgets/primary_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Pesanan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 15, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: PrimaryButton(label: "Pesan Lagi", onPressed: () => _reorder(context)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header info pesanan
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    OrderStatusBadge(status: order.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(order.date),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle("Status Pesanan"),
          const SizedBox(height: 12),
          _statusTimeline(),
          const SizedBox(height: 20),
          const SectionTitle("Item Pesanan"),
          const SizedBox(height: 8),

          ...order.items.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text("${formatRupiah(item.product.price)} x ${item.quantity}"),
              trailing: Text(
                formatRupiah(item.subtotal),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
              ),
            ),
          ),

          if (order.notes.isNotEmpty) ...[
            const SizedBox(height: 20),
            const SectionTitle("Catatan Pesanan"),
            const SizedBox(height: 8),
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.sticky_note_2_outlined, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(order.notes,
                        style: const TextStyle(color: AppColors.textPrimary)),
                  ),
                ],
              ),
            ),
          ],

          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                formatRupiah(order.total),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4CAF50)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Memasukkan kembali item pesanan ini ke keranjang (item habis/dihapus
  /// dilewati), lalu memberi feedback snackbar. Tidak memaksa navigasi.
  void _reorder(BuildContext context) {
    final result = reorderIntoCart(
      cart: context.read<CartProvider>(),
      order: order,
      menu: kMenu,
    );

    final String message;
    final Color background;
    if (result.nothingAdded) {
      message = "Semua item sudah tidak tersedia 😢";
      background = AppColors.error;
    } else if (result.skipped > 0) {
      message =
          "${result.added} item ditambahkan, ${result.skipped} item tidak tersedia & dilewati";
      background = AppColors.primary;
    } else {
      message = "${result.added} item ditambahkan ke keranjang";
      background = AppColors.primary;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: background,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  /// Timeline progres pesanan (vertikal). Untuk pesanan dibatalkan,
  /// tampilkan catatan alih-alih timeline.
  Widget _statusTimeline() {
    if (order.status == OrderStatus.dibatalkan) {
      return AppCard(
        child: Row(
          children: const [
            Icon(Icons.cancel, color: AppColors.error),
            SizedBox(width: AppSpacing.sm),
            Text(
              "Pesanan dibatalkan",
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    const steps = [
      OrderStatus.diproses,
      OrderStatus.disiapkan,
      OrderStatus.dikirim,
      OrderStatus.selesai,
    ];
    final current = order.status.index;
    final eta = estimatedDelivery(order);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (eta != null) ...[
            Row(
              children: [
                const Icon(Icons.delivery_dining, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text("Estimasi tiba $eta",
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const Divider(height: AppSpacing.lg),
          ],
          ...List.generate(steps.length, (i) {
          final reached = i <= current;
          final isLast = i == steps.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      reached ? Icons.check_circle : Icons.radio_button_unchecked,
                      size: 20,
                      color: reached ? AppColors.primary : AppColors.border,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: i < current ? AppColors.primary : AppColors.border,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm + 4),
                Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
                  child: Text(
                    steps[i].label,
                    style: TextStyle(
                      fontWeight: reached ? FontWeight.w600 : FontWeight.normal,
                      color: reached ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        ],
      ),
    );
  }
}

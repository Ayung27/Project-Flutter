import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_providers.dart';
import 'package:intl/intl.dart';
import 'order_detail_screen.dart';
import '../utils/currency.dart';
import '../widgets/empty_state.dart';
import '../widgets/app_card.dart';
import '../widgets/order_status_badge.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: cartProv.orders.isEmpty
          ? const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: "Belum ada pesanan",
              message: "Riwayat pesananmu akan muncul di sini.",
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              itemCount: cartProv.orders.length,
              itemBuilder: (context, index) {
                final order = cartProv.orders[index];
                return AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.id,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                          OrderStatusBadge(status: order.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd MMM yyyy, HH:mm').format(order.date),
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatRupiah(order.total),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              InkWell(
                                onTap: () => cartProv.hapusHistory(index),
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                child: const Padding(
                                  padding: EdgeInsets.all(AppSpacing.xs),
                                  child: Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
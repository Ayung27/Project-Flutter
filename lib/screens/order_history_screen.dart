import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_providers.dart';
import 'package:intl/intl.dart';
import 'order_detail_screen.dart';
import '../utils/currency.dart';

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
          ? const Center(child: Text("Belum ada riwayat pesanan"))
          : ListView.builder(
              itemCount: cartProv.orders.length,
              itemBuilder: (context, index) {
                final order = cartProv.orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(Icons.receipt_long, color: Colors.white),
                    ),
                    title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("Total: ${formatRupiah(order.total)}\n${DateFormat('dd MMM yyyy, HH:mm').format(order.date)}"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => cartProv.hapusHistory(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
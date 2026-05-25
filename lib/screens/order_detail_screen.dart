import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../utils/currency.dart';

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
                Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(order.date),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text("Item Pesanan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
}

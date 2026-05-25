import 'cart_item.dart';
import 'order_status.dart';

/// Satu pesanan yang sudah di-checkout (snapshot keranjang + total + status).
class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final int total;
  final OrderStatus status;

  /// Catatan opsional dari user (mis. "jangan pedas"). Kosong = tanpa catatan.
  final String notes;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    this.status = OrderStatus.diproses,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
        'total': total,
        'status': status.name,
        'notes': notes,
      };

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? []);
    return Order(
      id: json['id'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      items: rawItems
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      // Data lama belum punya 'status' → fallback ke selesai.
      status: OrderStatusLabel.fromName(json['status']),
      // Data lama belum punya 'notes' → fallback kosong.
      notes: json['notes'] as String? ?? '',
    );
  }
}

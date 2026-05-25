import 'cart_item.dart';

/// Satu pesanan yang sudah di-checkout (snapshot keranjang + total).
class Order {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final int total;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
        'total': total,
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
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/models/cart_item.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/models/order_status.dart';
import 'package:food_app/utils/delivery.dart';

void main() {
  Order orderOf(List<CartItem> items, OrderStatus status) =>
      Order(id: 'x', date: DateTime(2026), items: items, total: 0, status: status);

  test('estimasi in-progress dihitung dari total quantity (deterministik)', () {
    final order = orderOf([
      CartItem(product: const Product(name: 'A', price: 1000), quantity: 2),
      CartItem(product: const Product(name: 'B', price: 1000), quantity: 1),
    ], OrderStatus.diproses);

    // 20 + (3 * 2) = 26, max = 26 + 10 = 36
    expect(estimatedDelivery(order), '26–36 menit');
  });

  test('null untuk order selesai', () {
    final order = orderOf(const [], OrderStatus.selesai);
    expect(estimatedDelivery(order), isNull);
  });

  test('null untuk order dibatalkan', () {
    final order = orderOf(const [], OrderStatus.dibatalkan);
    expect(estimatedDelivery(order), isNull);
  });
}

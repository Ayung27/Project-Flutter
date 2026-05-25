import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/models/cart_item.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/utils/recommendations.dart';

void main() {
  const nasi = Product(name: 'Nasi Goreng', price: 25000, available: true);
  const kopi = Product(name: 'Kopi Susu', price: 18000, available: true);
  const burgerHabis = Product(name: 'Burger Beef', price: 35000, available: false);
  const menu = [nasi, kopi, burgerHabis];

  Order orderOf(List<CartItem> items) =>
      Order(id: 'x', date: DateTime(2026), items: items, total: 0);

  test('kosong bila belum ada order', () {
    expect(recentlyOrdered(const [], menu), isEmpty);
  });

  test('mengurutkan berdasarkan frekuensi (terbanyak dulu)', () {
    final orders = [
      orderOf([CartItem(product: nasi, quantity: 2)]),
      orderOf([CartItem(product: kopi, quantity: 1), CartItem(product: nasi, quantity: 1)]),
    ];

    final result = recentlyOrdered(orders, menu);

    expect(result.map((p) => p.name).toList(), ['Nasi Goreng', 'Kopi Susu']);
  });

  test('mengecualikan produk yang tidak tersedia / tidak ada di menu', () {
    final orders = [
      orderOf([CartItem(product: burgerHabis, quantity: 5)]),
      orderOf([CartItem(product: kopi, quantity: 1)]),
    ];

    final result = recentlyOrdered(orders, menu);

    expect(result.map((p) => p.name).toList(), ['Kopi Susu']);
  });
}

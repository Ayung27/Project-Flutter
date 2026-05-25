import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/models/cart_item.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/utils/reorder.dart';

void main() {
  const nasi = Product(name: 'Nasi Goreng', price: 25000, available: true);
  const kopi = Product(name: 'Kopi Susu', price: 18000, available: true);
  const burgerHabis = Product(name: 'Burger Beef', price: 35000, available: false);

  const menu = [nasi, kopi, burgerHabis];

  Order orderOf(List<CartItem> items) =>
      Order(id: 'ORD-1', date: DateTime(2026), items: items, total: 0);

  test('menambahkan item tersedia ke cart dengan quantity dipertahankan', () {
    final cart = CartProvider();
    final order = orderOf([
      CartItem(product: nasi, quantity: 2),
      CartItem(product: kopi, quantity: 1),
    ]);

    final result = reorderIntoCart(cart: cart, order: order, menu: menu);

    expect(result.added, 2);
    expect(result.skipped, 0);
    expect(cart.items.length, 2);
    expect(cart.items.firstWhere((i) => i.product.name == 'Nasi Goreng').quantity, 2);
  });

  test('melewati item yang habis dan yang tidak ada di menu', () {
    final cart = CartProvider();
    final order = orderOf([
      CartItem(product: nasi, quantity: 1),
      CartItem(product: burgerHabis, quantity: 1), // habis → skip
      CartItem(product: const Product(name: 'Menu Dihapus', price: 9999), quantity: 1), // tak ada → skip
    ]);

    final result = reorderIntoCart(cart: cart, order: order, menu: menu);

    expect(result.added, 1);
    expect(result.skipped, 2);
    expect(cart.items.single.product.name, 'Nasi Goreng');
  });

  test('semua item tidak tersedia → nothingAdded true', () {
    final cart = CartProvider();
    final order = orderOf([CartItem(product: burgerHabis, quantity: 1)]);

    final result = reorderIntoCart(cart: cart, order: order, menu: menu);

    expect(result.added, 0);
    expect(result.nothingAdded, isTrue);
    expect(cart.items, isEmpty);
  });

  test('merge dengan item yang sudah ada di cart', () {
    final cart = CartProvider()..addItem(nasi); // qty 1
    final order = orderOf([CartItem(product: nasi, quantity: 2)]);

    reorderIntoCart(cart: cart, order: order, menu: menu);

    expect(cart.items.single.quantity, 3); // 1 + 2
  });
}

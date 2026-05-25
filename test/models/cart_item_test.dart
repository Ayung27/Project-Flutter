import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/models/cart_item.dart';

void main() {
  group('CartItem', () {
    const product = Product(name: 'Burger Beef', price: 35000);

    test('quantity default 1', () {
      final item = CartItem(product: product);
      expect(item.quantity, 1);
    });

    test('subtotal = harga produk dikali quantity', () {
      final item = CartItem(product: product, quantity: 3);
      expect(item.subtotal, 105000);
    });
  });
}

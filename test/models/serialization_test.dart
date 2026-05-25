import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/models/cart_item.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/models/order_status.dart';
import 'package:food_app/models/alamat.dart';

void main() {
  group('Product JSON', () {
    test('round-trip mempertahankan seluruh field', () {
      const product = Product(
        name: 'Nasi Goreng',
        price: 25000,
        imageUrl: 'https://example.com/nasi.jpg',
        rating: 4.8,
      );

      final restored = Product.fromJson(product.toJson());

      expect(restored.name, product.name);
      expect(restored.price, product.price);
      expect(restored.imageUrl, product.imageUrl);
      expect(restored.rating, product.rating);
    });

    test('available default true bila tidak ada di JSON (backward-compat)', () {
      final restored = Product.fromJson({'name': 'Lama', 'price': 1000});
      expect(restored.available, isTrue);
    });

    test('round-trip mempertahankan available=false', () {
      const product = Product(name: 'Habis', price: 1000, available: false);
      expect(Product.fromJson(product.toJson()).available, isFalse);
    });

    test('category default kosong bila tidak ada di JSON (backward-compat)', () {
      final restored = Product.fromJson({'name': 'Lama', 'price': 1000});
      expect(restored.category, '');
    });

    test('round-trip mempertahankan category', () {
      const product = Product(name: 'Kopi Susu', price: 18000, category: 'Kopi');
      expect(Product.fromJson(product.toJson()).category, 'Kopi');
    });
  });

  group('CartItem JSON', () {
    test('round-trip mempertahankan product dan quantity', () {
      final item = CartItem(
        product: const Product(name: 'Burger', price: 35000),
        quantity: 3,
      );

      final restored = CartItem.fromJson(item.toJson());

      expect(restored.product.name, 'Burger');
      expect(restored.product.price, 35000);
      expect(restored.quantity, 3);
    });
  });

  group('Order JSON', () {
    test('round-trip mempertahankan id, tanggal, items, dan total', () {
      final order = Order(
        id: 'ORD-123',
        date: DateTime(2026, 5, 25, 14, 30),
        items: [
          CartItem(product: const Product(name: 'Ayam', price: 20000), quantity: 2),
        ],
        total: 40000,
      );

      final restored = Order.fromJson(order.toJson());

      expect(restored.id, 'ORD-123');
      expect(restored.date, DateTime(2026, 5, 25, 14, 30));
      expect(restored.total, 40000);
      expect(restored.items.single.product.name, 'Ayam');
      expect(restored.items.single.quantity, 2);
    });

    test('order baru default berstatus diproses', () {
      final order = Order(id: 'x', date: DateTime(2026), items: const [], total: 0);
      expect(order.status, OrderStatus.diproses);
    });

    test('round-trip mempertahankan status', () {
      final order = Order(
        id: 'x',
        date: DateTime(2026),
        items: const [],
        total: 0,
        status: OrderStatus.dikirim,
      );
      expect(Order.fromJson(order.toJson()).status, OrderStatus.dikirim);
    });

    test('data lama tanpa status fallback ke selesai (backward-compat)', () {
      final legacy = {
        'id': 'OLD',
        'date': '2026-01-01T00:00:00.000',
        'items': <dynamic>[],
        'total': 1000,
      };
      expect(Order.fromJson(legacy).status, OrderStatus.selesai);
    });

    test('notes default kosong bila tidak ada di JSON (backward-compat)', () {
      final legacy = {
        'id': 'OLD',
        'date': '2026-01-01T00:00:00.000',
        'items': <dynamic>[],
        'total': 1000,
      };
      expect(Order.fromJson(legacy).notes, '');
    });

    test('round-trip mempertahankan notes', () {
      final order = Order(
        id: 'x',
        date: DateTime(2026),
        items: const [],
        total: 0,
        notes: 'jangan pedas, saus dipisah',
      );
      expect(Order.fromJson(order.toJson()).notes, 'jangan pedas, saus dipisah');
    });
  });

  group('Alamat JSON', () {
    test('round-trip mempertahankan label, detail, dan icon', () {
      const alamat = Alamat(label: 'Rumah', detail: 'Jl. Contoh 123', icon: 'home');

      final restored = Alamat.fromJson(alamat.toJson());

      expect(restored.label, 'Rumah');
      expect(restored.detail, 'Jl. Contoh 123');
      expect(restored.icon, 'home');
    });
  });
}

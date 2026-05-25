import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const nasi = Product(name: 'Nasi Goreng Spesial', price: 25000);
  const ayam = Product(name: 'Ayam Geprek Matah', price: 20000);

  group('logic (in-memory)', () {
    late CartProvider cart;

    setUp(() => cart = CartProvider());

    test('addItem menambah produk baru dengan quantity 1', () {
      cart.addItem(nasi);

      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 1);
      expect(cart.items.first.product.name, 'Nasi Goreng Spesial');
    });

    test('addItem pada produk yang sama menambah quantity, bukan baris baru', () {
      cart.addItem(nasi);
      cart.addItem(nasi);

      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
    });

    test('totalBayar menjumlahkan subtotal seluruh item', () {
      cart.addItem(nasi);
      cart.addItem(nasi);
      cart.addItem(ayam);

      expect(cart.totalBayar, 25000 * 2 + 20000);
    });

    test('addOrder memindahkan keranjang ke riwayat dan mengosongkan keranjang', () {
      cart.addItem(nasi);
      cart.addOrder(50000);

      expect(cart.items, isEmpty);
      expect(cart.orders.length, 1);
      expect(cart.orders.first.total, 50000);
    });

    test('removeItem menghapus item sesuai index', () {
      cart.addItem(nasi);
      cart.addItem(ayam);
      cart.removeItem(0);

      expect(cart.items.length, 1);
      expect(cart.items.first.product.name, 'Ayam Geprek Matah');
    });
  });

  group('persistence', () {
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
    });

    test('keranjang bertahan setelah dimuat ulang dari storage', () {
      CartProvider(storage: storage)
        ..addItem(nasi)
        ..addItem(nasi);

      final reloaded = CartProvider(storage: storage)..load();

      expect(reloaded.items.length, 1);
      expect(reloaded.items.first.quantity, 2);
      expect(reloaded.items.first.product.name, 'Nasi Goreng Spesial');
    });

    test('riwayat order bertahan setelah dimuat ulang dari storage', () {
      CartProvider(storage: storage)
        ..addItem(nasi)
        ..addOrder(50000);

      final reloaded = CartProvider(storage: storage)..load();

      expect(reloaded.orders.length, 1);
      expect(reloaded.orders.first.total, 50000);
      expect(reloaded.items, isEmpty);
    });
  });

  group('voucher', () {
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
    });

    test('applyVoucher menolak kode tidak valid', () {
      final cart = CartProvider(storage: storage);

      expect(cart.applyVoucher('NGAWUR'), isNotNull);
      expect(cart.appliedVoucher, isNull);
    });

    test('discount mengikuti voucher persen atas subtotal', () {
      final cart = CartProvider(storage: storage)
        ..addItem(nasi)
        ..addItem(nasi); // subtotal 50000

      expect(cart.applyVoucher('DISKON50'), isNull); // sukses
      expect(cart.discount, 25000);
    });

    test('voucher yang diterapkan bertahan setelah dimuat ulang', () {
      CartProvider(storage: storage)
        ..addItem(nasi)
        ..applyVoucher('DISKON50');

      final reloaded = CartProvider(storage: storage)..load();

      expect(reloaded.appliedVoucher?.code, 'DISKON50');
    });

    test('addOrder menghapus voucher yang diterapkan', () {
      final cart = CartProvider(storage: storage)
        ..addItem(nasi)
        ..applyVoucher('DISKON50');

      cart.addOrder(cart.totalBayar - cart.discount);

      expect(cart.appliedVoucher, isNull);
    });
  });
}

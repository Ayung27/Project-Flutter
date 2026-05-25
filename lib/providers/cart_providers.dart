import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/voucher.dart';
import '../services/storage_service.dart';

class CartProvider with ChangeNotifier {
  static const _cartKey = 'cart';
  static const _ordersKey = 'orders';
  static const _voucherKey = 'voucher';

  // Storage opsional: bila null, provider berjalan murni in-memory
  // (dipakai di unit test logika & widget test).
  final StorageService? _storage;

  CartProvider({StorageService? storage}) : _storage = storage;

  // Keranjang saat ini (item bertipe).
  final List<CartItem> _items = [];

  // Riwayat pesanan yang sudah dibuat.
  final List<Order> _orders = [];

  // Voucher yang sedang diterapkan (null = tidak ada).
  Voucher? _voucher;

  List<CartItem> get items => _items;
  List<Order> get orders => _orders;
  Voucher? get appliedVoucher => _voucher;

  /// Nominal diskon dari voucher aktif terhadap subtotal saat ini.
  int get discount => _voucher?.discountFor(totalBayar) ?? 0;

  /// Memuat keranjang & riwayat dari storage. Aman dipanggil saat startup;
  /// no-op bila storage tidak tersedia.
  void load() {
    final storage = _storage;
    if (storage == null) return;

    _items
      ..clear()
      ..addAll(storage.readJsonList(_cartKey).map(CartItem.fromJson));
    _orders
      ..clear()
      ..addAll(storage.readJsonList(_ordersKey).map(Order.fromJson));

    final savedVoucher = storage.readJsonList(_voucherKey);
    _voucher = savedVoucher.isEmpty ? null : Voucher.fromJson(savedVoucher.first);

    notifyListeners();
  }

  /// Menerapkan voucher berdasarkan kode. Mengembalikan null bila sukses,
  /// atau pesan error bila kode tidak valid.
  String? applyVoucher(String code) {
    final voucher = findVoucher(code);
    if (voucher == null) return 'Kode voucher tidak valid';
    _voucher = voucher;
    _persistVoucher();
    notifyListeners();
    return null;
  }

  void removeVoucher() {
    _voucher = null;
    _persistVoucher();
    notifyListeners();
  }

  void addItem(Product product) {
    final index = _items.indexWhere((item) => item.product.name == product.name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    _persistCart();
    notifyListeners();
  }

  /// Menambah [product] sebanyak [quantity] (merge bila sudah ada di cart).
  /// Dipakai oleh fitur reorder. Satu notifyListeners untuk seluruh quantity.
  void addQuantity(Product product, int quantity) {
    if (quantity <= 0) return;
    final index = _items.indexWhere((item) => item.product.name == product.name);
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    _persistCart();
    notifyListeners();
  }

  void updateQuantity(int index, bool isAdd) {
    if (isAdd) {
      _items[index].quantity++;
    } else {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
    _persistCart();
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _persistCart();
      notifyListeners();
    }
  }

  int get totalBayar => _items.fold(0, (total, item) => total + item.subtotal);

  // Memindahkan keranjang ke riwayat pesanan, lalu mengosongkan keranjang.
  void addOrder(int totalHarga, {String notes = ''}) {
    if (_items.isNotEmpty) {
      _orders.insert(
        0,
        Order(
          id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime.now(),
          items: List<CartItem>.from(_items), // Copy data keranjang
          total: totalHarga,
          notes: notes,
        ),
      );
      _items.clear();
      _voucher = null; // voucher hangus setelah checkout
      _persistOrders();
      _persistCart();
      _persistVoucher();
      notifyListeners();
    }
  }

  // Hapus riwayat pesanan tertentu.
  void hapusHistory(int index) {
    _orders.removeAt(index);
    _persistOrders();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _persistCart();
    notifyListeners();
  }

  void _persistCart() {
    _storage?.writeJsonList(_cartKey, _items.map((e) => e.toJson()).toList());
  }

  void _persistOrders() {
    _storage?.writeJsonList(_ordersKey, _orders.map((e) => e.toJson()).toList());
  }

  void _persistVoucher() {
    _storage?.writeJsonList(_voucherKey, _voucher == null ? [] : [_voucher!.toJson()]);
  }
}

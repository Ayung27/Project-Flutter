import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  // List untuk menyimpan data keranjang (saat ini)
  final List<Map<String, dynamic>> _items = [];
  
  // --- TAMBAHAN: List untuk menyimpan riwayat pesanan yang sudah dibuat ---
  final List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get items => _items;
  List<Map<String, dynamic>> get orders => _orders; // Getter untuk riwayat pesanan

  void addItem(Map<String, dynamic> product) {
    int index = _items.indexWhere((item) => item['nama'] == product['nama']);
    if (index >= 0) {
      _items[index]['quantity'] = (_items[index]['quantity'] ?? 1) + 1;
    } else {
      product['quantity'] = 1;
      _items.add(product);
    }
    notifyListeners(); 
  }

  void updateQuantity(int index, bool isAdd) {
    if (isAdd) {
      _items[index]['quantity']++;
    } else {
      if (_items[index]['quantity'] > 1) {
        _items[index]['quantity']--;
      } else {
        _items.removeAt(index);
      }
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  int get totalBayar {
    int total = 0;
    for (var item in _items) {
      String priceStr = item['harga'].toString().replaceAll(RegExp(r'[^0-9]'), '');
      int price = int.tryParse(priceStr) ?? 0;
      int qty = item['quantity'] ?? 1;
      total += price * qty;
    }
    return total;
  }

  // --- TAMBAHAN: Fungsi untuk memindahkan keranjang ke riwayat pesanan ---
  void addOrder(int totalHarga) {
    if (_items.isNotEmpty) {
      _orders.insert(0, {
        'id': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        'tanggal': DateTime.now(),
        'items': List.from(_items), // Copy data keranjang
        'total': totalHarga,
      });
      _items.clear(); // Bersihkan keranjang setelah dipindah ke order
      notifyListeners();
    }
  }

  // Fungsi hapus riwayat pesanan tertentu
  void hapusHistory(int index) {
    _orders.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
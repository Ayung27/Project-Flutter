import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Menyimpan menu favorit user (di-key berdasarkan nama produk, konsisten
/// dengan pencocokan keranjang). Dipersist via [StorageService].
class FavoritesProvider with ChangeNotifier {
  static const _key = 'favorites';

  final StorageService? _storage;
  final Set<String> _ids = {};

  FavoritesProvider({StorageService? storage}) : _storage = storage;

  bool isFavorite(String id) => _ids.contains(id);
  bool get isEmpty => _ids.isEmpty;
  Set<String> get ids => _ids;

  /// Memuat favorit dari storage. No-op bila storage tidak tersedia.
  void load() {
    final storage = _storage;
    if (storage == null) return;
    _ids
      ..clear()
      ..addAll(storage.readStringList(_key));
    notifyListeners();
  }

  void toggle(String id) {
    if (!_ids.remove(id)) {
      _ids.add(id);
    }
    _persist();
    notifyListeners();
  }

  void _persist() {
    _storage?.writeStringList(_key, _ids.toList());
  }
}

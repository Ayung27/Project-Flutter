import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper tipis di atas [SharedPreferences] untuk menyimpan/membaca
/// list JSON. Serialisasi tiap entitas tetap berada di model masing-masing
/// (toJson/fromJson) — service ini hanya menangani encode/decode list.
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Membaca list map dari [key]. Mengembalikan list kosong bila belum ada
  /// atau bila data rusak (gagal decode) — aman untuk loading awal.
  List<Map<String, dynamic>> readJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> writeJsonList(String key, List<Map<String, dynamic>> value) {
    return _prefs.setString(key, jsonEncode(value));
  }

  /// True bila [key] pernah ditulis (termasuk bila isinya list kosong).
  bool containsKey(String key) => _prefs.containsKey(key);
}

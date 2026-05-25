import 'package:flutter/material.dart';
import '../models/alamat.dart';
import '../services/storage_service.dart';

class AlamatProvider with ChangeNotifier {
  static const _key = 'alamat';

  final StorageService? _storage;

  AlamatProvider({StorageService? storage}) : _storage = storage;

  // Data default awal (dipakai hanya pada first run).
  final List<Alamat> _daftarAlamat = [
    const Alamat(
      label: "Rumah",
      detail: "Jl. Contoh No.123, Cipocok Jaya, Kota Serang, Banten.",
      icon: "home",
    ),
    const Alamat(
      label: "Kampus UIN SMH Banten",
      detail: "Jl. Jendral Sudirman No. 30, Panancangan, Kec. Cipocok Jaya, Kota Serang.",
      icon: "school",
    ),
  ];

  List<Alamat> get daftarAlamat => _daftarAlamat;

  /// Memuat alamat dari storage. Bila belum pernah disimpan (first run),
  /// default awal ikut dipersist. No-op bila storage tidak tersedia.
  void load() {
    final storage = _storage;
    if (storage == null) return;

    if (storage.containsKey(_key)) {
      _daftarAlamat
        ..clear()
        ..addAll(storage.readJsonList(_key).map(Alamat.fromJson));
    } else {
      _persist(); // first run: simpan default agar konsisten
    }
    notifyListeners();
  }

  void tambahAlamat(String nama, String detail) {
    _daftarAlamat.add(Alamat(label: nama, detail: detail));
    _persist();
    notifyListeners();
  }

  void hapusAlamat(int index) {
    _daftarAlamat.removeAt(index);
    _persist();
    notifyListeners();
  }

  void _persist() {
    _storage?.writeJsonList(_key, _daftarAlamat.map((e) => e.toJson()).toList());
  }
}

import 'package:flutter/material.dart';

class AlamatProvider with ChangeNotifier {
  // Data default awal
  final List<Map<String, String>> _daftarAlamat = [
    {
      "label": "Rumah",
      "detail": "Jl. Contoh No.123, Cipocok Jaya, Kota Serang, Banten.",
      "icon": "home"
    },
    {
      "label": "Kampus UIN SMH Banten",
      "detail": "Jl. Jendral Sudirman No. 30, Panancangan, Kec. Cipocok Jaya, Kota Serang.",
      "icon": "school"
    },
  ];

  List<Map<String, String>> get daftarAlamat => _daftarAlamat;

  // Fungsi Tambah Alamat
  void tambahAlamat(String nama, String detail) {
    _daftarAlamat.add({
      "label": nama,
      "detail": detail,
      "icon": "location_on",
    });
    notifyListeners(); // Memberitahu UI untuk update
  }

  // Fungsi Hapus Alamat
  void hapusAlamat(int index) {
    _daftarAlamat.removeAt(index);
    notifyListeners();
  }
}
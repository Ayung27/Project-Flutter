// Helper format & parse mata uang Rupiah.
// Disentralisasi di sini agar tidak diduplikasi di tiap screen.

/// Memformat [amount] (dalam Rupiah penuh) menjadi string seperti "Rp 25.000".
String formatRupiah(int amount) {
  final withSeparator = amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      );
  return 'Rp $withSeparator';
}

/// Mengekstrak nilai integer Rupiah dari [text] (mis. "Rp 25.000" -> 25000).
/// Mengembalikan 0 bila tidak ada angka yang ditemukan.
int parseRupiah(String text) {
  final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(digits) ?? 0;
}

/// Status siklus hidup sebuah pesanan.
/// Urutan enum mengikuti progres normal: diproses → disiapkan → dikirim → selesai.
/// (dibatalkan berada di luar alur linear tersebut.)
enum OrderStatus { diproses, disiapkan, dikirim, selesai, dibatalkan }

extension OrderStatusLabel on OrderStatus {
  /// Label tampilan berbahasa Indonesia.
  String get label {
    switch (this) {
      case OrderStatus.diproses:
        return 'Diproses';
      case OrderStatus.disiapkan:
        return 'Disiapkan';
      case OrderStatus.dikirim:
        return 'Dikirim';
      case OrderStatus.selesai:
        return 'Selesai';
      case OrderStatus.dibatalkan:
        return 'Dibatalkan';
    }
  }

  /// Parse aman dari string tersimpan. Data lama tanpa status → [OrderStatus.selesai].
  static OrderStatus fromName(Object? raw) {
    if (raw is String) {
      for (final status in OrderStatus.values) {
        if (status.name == raw) return status;
      }
    }
    return OrderStatus.selesai;
  }
}

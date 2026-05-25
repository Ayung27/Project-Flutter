/// Jenis diskon voucher.
enum DiscountType { percent, fixed }

/// Voucher diskon. [value] berarti persen (0-100) untuk [DiscountType.percent],
/// atau nominal Rupiah untuk [DiscountType.fixed].
class Voucher {
  final String code;
  final String label;
  final DiscountType type;
  final int value;

  const Voucher({
    required this.code,
    required this.label,
    required this.type,
    required this.value,
  });

  /// Diskon untuk [subtotal]. Tidak pernah melebihi subtotal.
  int discountFor(int subtotal) {
    final raw = type == DiscountType.percent ? (subtotal * value) ~/ 100 : value;
    return raw > subtotal ? subtotal : raw;
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'label': label,
        'type': type.name,
        'value': value,
      };

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      code: json['code'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: DiscountType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DiscountType.fixed,
      ),
      value: (json['value'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Daftar voucher demo yang tersedia (hardcoded).
const List<Voucher> kAvailableVouchers = [
  Voucher(code: 'DISKON50', label: 'Diskon 50%', type: DiscountType.percent, value: 50),
  Voucher(code: 'HEMAT10K', label: 'Potongan Rp 10.000', type: DiscountType.fixed, value: 10000),
];

/// Mencari voucher berdasarkan [code] (case-insensitive). Null bila tidak ada.
Voucher? findVoucher(String code) {
  final normalized = code.trim().toUpperCase();
  for (final voucher in kAvailableVouchers) {
    if (voucher.code == normalized) return voucher;
  }
  return null;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/voucher.dart';

void main() {
  group('discountFor', () {
    test('voucher persen menghitung persentase dari subtotal', () {
      const v = Voucher(code: 'DISKON50', label: '50%', type: DiscountType.percent, value: 50);
      expect(v.discountFor(40000), 20000);
    });

    test('voucher nominal memotong nilai tetap', () {
      const v = Voucher(code: 'HEMAT10K', label: '10rb', type: DiscountType.fixed, value: 10000);
      expect(v.discountFor(40000), 10000);
    });

    test('diskon tidak boleh melebihi subtotal (clamp)', () {
      const v = Voucher(code: 'HEMAT10K', label: '10rb', type: DiscountType.fixed, value: 10000);
      expect(v.discountFor(5000), 5000);
    });
  });

  group('findVoucher', () {
    test('menemukan voucher tanpa peduli huruf besar/kecil', () {
      expect(findVoucher('diskon50')?.code, 'DISKON50');
    });

    test('mengembalikan null untuk kode tidak dikenal', () {
      expect(findVoucher('NGAWUR'), isNull);
    });
  });

  group('Voucher JSON', () {
    test('round-trip mempertahankan seluruh field', () {
      const v = Voucher(code: 'DISKON50', label: '50%', type: DiscountType.percent, value: 50);
      final restored = Voucher.fromJson(v.toJson());
      expect(restored.code, 'DISKON50');
      expect(restored.type, DiscountType.percent);
      expect(restored.value, 50);
    });
  });
}

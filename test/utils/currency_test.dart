import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/utils/currency.dart';

void main() {
  group('formatRupiah', () {
    test('memformat ribuan dengan pemisah titik', () {
      expect(formatRupiah(25000), 'Rp 25.000');
    });

    test('memformat jutaan dengan dua pemisah titik', () {
      expect(formatRupiah(1500000), 'Rp 1.500.000');
    });

    test('memformat nol tanpa pemisah', () {
      expect(formatRupiah(0), 'Rp 0');
    });
  });

  group('parseRupiah', () {
    test('mengekstrak angka dari string berformat rupiah', () {
      expect(parseRupiah('Rp 25.000'), 25000);
    });

    test('mengekstrak angka dari string tanpa prefix', () {
      expect(parseRupiah('20.000'), 20000);
    });

    test('mengembalikan 0 untuk string tanpa angka', () {
      expect(parseRupiah(''), 0);
    });
  });
}

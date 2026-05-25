import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/product.dart';

void main() {
  group('Product.fromMap', () {
    test('mengonversi map menu (harga string) menjadi Product bertipe', () {
      final product = Product.fromMap({
        'nama': 'Nasi Goreng Spesial',
        'harga': 'Rp 25.000',
        'img': 'https://example.com/nasi.jpg',
        'rating': '4.8',
      });

      expect(product.name, 'Nasi Goreng Spesial');
      expect(product.price, 25000);
      expect(product.imageUrl, 'https://example.com/nasi.jpg');
      expect(product.rating, 4.8);
    });

    test('memberi nilai default aman bila field hilang', () {
      final product = Product.fromMap({'nama': 'Tanpa Harga'});

      expect(product.name, 'Tanpa Harga');
      expect(product.price, 0);
      expect(product.imageUrl, '');
      expect(product.rating, 0);
    });
  });
}

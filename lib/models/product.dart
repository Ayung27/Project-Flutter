import '../utils/currency.dart';

/// Entitas menu/makanan yang bisa dipesan.
///
/// Harga disimpan sebagai [int] (Rupiah penuh), bukan string tampilan,
/// sehingga aman untuk dihitung dan diserialisasi nanti.
class Product {
  final String name;
  final int price;
  final String imageUrl;
  final double rating;

  /// Apakah produk tersedia untuk dipesan (false = "Habis").
  final bool available;

  const Product({
    required this.name,
    required this.price,
    this.imageUrl = '',
    this.rating = 0,
    this.available = true,
  });

  /// Membuat [Product] dari map menu lama yang memakai harga string
  /// (mis. "Rp 25.000") dan key `img`/`imageUrl`.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['nama']?.toString() ?? '',
      price: parseRupiah(map['harga']?.toString() ?? ''),
      imageUrl: (map['img'] ?? map['imageUrl'] ?? '').toString(),
      rating: double.tryParse(map['rating']?.toString() ?? '') ?? 0,
    );
  }

  /// Serialisasi untuk persistensi (key bersih, harga sudah berupa int).
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'rating': rating,
        'available': available,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      available: json['available'] as bool? ?? true,
    );
  }
}

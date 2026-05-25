import '../models/order.dart';
import '../models/product.dart';

/// Rekomendasi berbasis data NYATA: menu yang pernah dipesan user,
/// diurutkan dari yang paling sering (akumulasi quantity), dibatasi [limit].
///
/// Hanya mengembalikan produk yang masih ada di [menu] dan tersedia — sehingga
/// aman saat menu berubah. Tidak ada rekomendasi acak/palsu.
List<Product> recentlyOrdered(
  List<Order> orders,
  List<Product> menu, {
  int limit = 8,
}) {
  if (orders.isEmpty) return const [];

  final frequency = <String, int>{};
  for (final order in orders) {
    for (final item in order.items) {
      frequency[item.product.name] =
          (frequency[item.product.name] ?? 0) + item.quantity;
    }
  }

  final result =
      menu.where((p) => p.available && frequency.containsKey(p.name)).toList();
  result.sort((a, b) => frequency[b.name]!.compareTo(frequency[a.name]!));

  return result.length > limit ? result.sublist(0, limit) : result;
}

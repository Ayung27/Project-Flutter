import '../models/order.dart';
import '../models/product.dart';
import '../providers/cart_providers.dart';

/// Ringkasan hasil reorder.
class ReorderResult {
  final int added;
  final int skipped;

  const ReorderResult({required this.added, required this.skipped});

  bool get nothingAdded => added == 0;
}

/// Memasukkan kembali item [order] ke [cart], mengacu pada [menu] terkini:
/// - item yang produknya masih ada di menu DAN tersedia → ditambahkan
///   (quantity dipertahankan, dengan harga/stok terbaru dari menu).
/// - item yang habis atau sudah dihapus dari menu → dilewati.
ReorderResult reorderIntoCart({
  required CartProvider cart,
  required Order order,
  required List<Product> menu,
}) {
  int added = 0;
  int skipped = 0;

  for (final item in order.items) {
    Product? current;
    for (final p in menu) {
      if (p.name == item.product.name && p.available) {
        current = p;
        break;
      }
    }
    if (current != null) {
      cart.addQuantity(current, item.quantity);
      added++;
    } else {
      skipped++;
    }
  }

  return ReorderResult(added: added, skipped: skipped);
}

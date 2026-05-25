import '../models/order.dart';
import '../models/order_status.dart';

/// Estimasi waktu tiba (dummy, deterministik) berbasis jumlah item.
/// Mengembalikan null untuk pesanan yang sudah selesai/dibatalkan.
///
/// Deterministik (bukan random) agar nilainya konsisten antar-rebuild.
String? estimatedDelivery(Order order) {
  if (order.status == OrderStatus.selesai || order.status == OrderStatus.dibatalkan) {
    return null;
  }
  final totalQty = order.items.fold<int>(0, (sum, item) => sum + item.quantity);
  final minMinutes = 20 + totalQty * 2;
  final maxMinutes = minMinutes + 10;
  return '$minMinutes–$maxMinutes menit';
}

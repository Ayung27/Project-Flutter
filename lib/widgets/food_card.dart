import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_providers.dart';
import '../utils/currency.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_card.dart';
import 'favorite_button.dart';

/// Kartu menu reusable (gambar + nama + rating + harga + favorit + tombol tambah).
/// Menangani add-to-cart & snackbar sendiri agar bisa dipakai di Home & Favorit
/// tanpa duplikasi.
class FoodCard extends StatelessWidget {
  final Product product;

  const FoodCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 88,
                    height: 88,
                    color: AppColors.fieldFill,
                    child: const Icon(Icons.fastfood, color: AppColors.textSecondary),
                  ),
                ),
                if (!product.available)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      alignment: Alignment.center,
                      child: const Text(
                        "Habis",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                Positioned(top: 4, right: 4, child: FavoriteButton(productId: product.name)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.star, size: 16),
                    Text(" ${product.rating}",
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  formatRupiah(product.price),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: product.available ? () => _addToCart(context) : null,
            icon: Icon(
              Icons.add_circle,
              color: product.available ? AppColors.primary : Colors.grey,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    context.read<CartProvider>().addItem(product);
    // Hindari antrian snackbar saat user menekan + berkali-kali cepat.
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          "${product.name} ditambah",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      ),
    );
  }
}

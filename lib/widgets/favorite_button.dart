import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_colors.dart';

/// Tombol favorit (❤️) untuk satu produk.
/// Memakai `context.select` sehingga hanya tombol INI yang rebuild saat
/// status favorit produk ini berubah — bukan seluruh homepage.
class FavoriteButton extends StatelessWidget {
  final String productId;

  const FavoriteButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final isFavorite =
        context.select<FavoritesProvider, bool>((f) => f.isFavorite(productId));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<FavoritesProvider>().toggle(productId),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: AppColors.shadow, blurRadius: 4, offset: const Offset(0, 1)),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey<bool>(isFavorite),
              color: isFavorite ? AppColors.error : AppColors.textSecondary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

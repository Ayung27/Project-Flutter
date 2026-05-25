import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/menu_data.dart';
import '../providers/favorites_provider.dart';
import '../widgets/food_card.dart';
import '../widgets/empty_state.dart';
import '../theme/app_spacing.dart';

class FavoriteScreen extends StatelessWidget {
  /// Dipanggil saat user menekan CTA "Eksplor Menu" pada empty state
  /// (mis. pindah ke tab Home).
  final VoidCallback? onExplore;

  const FavoriteScreen({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Favorit Saya", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, fav, _) {
          final favProducts = kMenu.where((p) => fav.isFavorite(p.name)).toList();

          if (favProducts.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: "Belum ada favorit",
              message: "Tandai menu favoritmu dengan ❤️ untuk menyimpannya di sini.",
              actionLabel: onExplore != null ? "Eksplor Menu" : null,
              onAction: onExplore,
            );
          }

          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: favProducts.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) => FoodCard(product: favProducts[i]),
            ),
          );
        },
      ),
    );
  }
}

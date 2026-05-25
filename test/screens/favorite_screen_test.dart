import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:food_app/providers/favorites_provider.dart';
import 'package:food_app/screens/favorite_screen.dart';

void main() {
  testWidgets('FavoriteScreen menampilkan empty state saat belum ada favorit',
      (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesProvider>(
        create: (_) => FavoritesProvider(), // in-memory, kosong
        child: const MaterialApp(home: FavoriteScreen()),
      ),
    );

    expect(find.text('Belum ada favorit'), findsOneWidget);
  });
}

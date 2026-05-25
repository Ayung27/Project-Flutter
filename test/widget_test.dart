// Widget smoke test untuk food_app.
//
// Logika CartProvider diuji terpisah di test/providers/cart_provider_test.dart.
// Di sini fokus memastikan CartScreen ter-render tanpa Firebase/GPS.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/screens/cart_screen.dart';

void main() {
  testWidgets('CartScreen menampilkan empty state saat keranjang kosong',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<CartProvider>(
        create: (_) => CartProvider(),
        child: const MaterialApp(home: CartScreen()),
      ),
    );

    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Keranjang kosong 😢'), findsOneWidget);
  });
}

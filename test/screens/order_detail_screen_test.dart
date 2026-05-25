import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/models/cart_item.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/screens/order_detail_screen.dart';

void main() {
  final order = Order(
    id: 'ORD-123',
    date: DateTime(2026, 5, 25, 14, 30),
    items: [
      CartItem(product: const Product(name: 'Nasi Goreng', price: 25000), quantity: 2),
      CartItem(product: const Product(name: 'Es Teh', price: 5000), quantity: 1),
    ],
    total: 55000,
  );

  testWidgets('OrderDetailScreen menampilkan id, item, dan total', (tester) async {
    await tester.pumpWidget(MaterialApp(home: OrderDetailScreen(order: order)));

    expect(find.text('ORD-123'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);

    // Total ada di bawah (ListView lazy + bottom bar "Pesan Lagi") → scroll dulu.
    await tester.scrollUntilVisible(
      find.text('Rp 55.000'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Rp 55.000'), findsOneWidget);
  });
}

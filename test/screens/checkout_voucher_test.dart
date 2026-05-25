import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:food_app/models/product.dart';
import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/screens/checkout_screen.dart';

void main() {
  // Subtotal 25.000 + ongkir 15.000 = 40.000 sebelum diskon.
  Future<CartProvider> pumpCheckout(WidgetTester tester) async {
    final cart = CartProvider()..addItem(const Product(name: 'Nasi Goreng', price: 25000));
    await tester.pumpWidget(
      ChangeNotifierProvider<CartProvider>.value(
        value: cart,
        child: const MaterialApp(home: CheckoutScreen()),
      ),
    );
    return cart;
  }

  Future<void> applyCode(WidgetTester tester, String code) async {
    // Field voucher adalah TextField pertama (sebelum field "Catatan").
    final voucherField = find.byType(TextField).first;
    await tester.ensureVisible(voucherField);
    await tester.enterText(voucherField, code);
    await tester.ensureVisible(find.widgetWithText(ElevatedButton, 'Pakai'));
    await tester.tap(find.widgetWithText(ElevatedButton, 'Pakai'));
    await tester.pump(); // proses notifyListeners + tampilkan snackbar
  }

  testWidgets('voucher valid menampilkan baris diskon', (tester) async {
    await pumpCheckout(tester);
    expect(find.text('Diskon Voucher'), findsNothing); // belum ada

    await applyCode(tester, 'DISKON50');

    expect(find.text('Diskon Voucher'), findsOneWidget);
    expect(find.text('-Rp 12.500'), findsOneWidget); // 50% dari 25.000
  });

  testWidgets('total akhir berubah sesuai diskon', (tester) async {
    await pumpCheckout(tester);
    expect(find.text('Rp 40.000'), findsOneWidget); // total sebelum diskon

    await applyCode(tester, 'DISKON50');

    expect(find.text('Rp 27.500'), findsOneWidget); // 40.000 - 12.500
    expect(find.text('Rp 40.000'), findsNothing); // total lama hilang
  });

  testWidgets('voucher invalid menampilkan snackbar error', (tester) async {
    await pumpCheckout(tester);

    await applyCode(tester, 'NGAWUR');

    expect(find.text('Kode voucher tidak valid'), findsOneWidget);
    expect(find.text('Diskon Voucher'), findsNothing);
  });
}

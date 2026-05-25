import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
  });

  test('readJsonList mengembalikan list kosong bila key belum ada', () {
    expect(storage.readJsonList('cart'), isEmpty);
  });

  test('writeJsonList lalu readJsonList melakukan round-trip data', () async {
    await storage.writeJsonList('cart', [
      {'name': 'Nasi', 'price': 25000},
      {'name': 'Ayam', 'price': 20000},
    ]);

    final result = storage.readJsonList('cart');

    expect(result, hasLength(2));
    expect(result.first['name'], 'Nasi');
    expect(result.last['price'], 20000);
  });

  test('containsKey membedakan belum-pernah-disimpan vs tersimpan-kosong', () async {
    expect(storage.containsKey('alamat'), isFalse);

    await storage.writeJsonList('alamat', []);

    expect(storage.containsKey('alamat'), isTrue);
    expect(storage.readJsonList('alamat'), isEmpty);
  });
}

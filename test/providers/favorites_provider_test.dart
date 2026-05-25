import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/providers/favorites_provider.dart';
import 'package:food_app/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
  });

  test('toggle menambah lalu menghapus favorit', () {
    final fav = FavoritesProvider(storage: storage);

    fav.toggle('Nasi Goreng');
    expect(fav.isFavorite('Nasi Goreng'), isTrue);

    fav.toggle('Nasi Goreng');
    expect(fav.isFavorite('Nasi Goreng'), isFalse);
  });

  test('favorit bertahan setelah dimuat ulang dari storage', () {
    FavoritesProvider(storage: storage)
      ..toggle('Nasi Goreng')
      ..toggle('Kopi Susu Gula Aren');

    final reloaded = FavoritesProvider(storage: storage)..load();

    expect(reloaded.isFavorite('Nasi Goreng'), isTrue);
    expect(reloaded.isFavorite('Kopi Susu Gula Aren'), isTrue);
    expect(reloaded.isFavorite('Burger Beef'), isFalse);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/providers/alamat_provider.dart';
import 'package:food_app/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storage = StorageService(prefs);
  });

  test('first run menampilkan alamat default', () {
    final prov = AlamatProvider(storage: storage)..load();

    expect(prov.daftarAlamat, isNotEmpty);
  });

  test('alamat baru bertahan setelah dimuat ulang dari storage', () {
    AlamatProvider(storage: storage)
      ..load()
      ..tambahAlamat('Kantor', 'Jl. Kerja No.1');

    final reloaded = AlamatProvider(storage: storage)..load();

    expect(reloaded.daftarAlamat.any((a) => a.label == 'Kantor'), isTrue);
  });

  test('menghapus semua alamat tidak memunculkan default lagi', () {
    final prov = AlamatProvider(storage: storage)..load();
    while (prov.daftarAlamat.isNotEmpty) {
      prov.hapusAlamat(0);
    }

    final reloaded = AlamatProvider(storage: storage)..load();

    expect(reloaded.daftarAlamat, isEmpty);
  });
}

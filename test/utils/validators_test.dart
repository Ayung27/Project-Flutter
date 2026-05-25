import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/utils/validators.dart';

void main() {
  group('emailError', () {
    test('mengembalikan pesan bila kosong', () {
      expect(emailError(''), isNotNull);
    });

    test('mengembalikan pesan bila format salah', () {
      expect(emailError('bukan-email'), isNotNull);
    });

    test('null untuk email .com yang valid', () {
      expect(emailError('user@mail.com'), isNull);
    });

    test('null untuk TLD non-.com (mis. .co.id)', () {
      expect(emailError('mahasiswa@kampus.co.id'), isNull);
    });
  });

  group('passwordError', () {
    test('mengembalikan pesan bila kurang dari 6 karakter', () {
      expect(passwordError('123'), isNotNull);
    });

    test('null untuk password minimal 6 karakter', () {
      expect(passwordError('123456'), isNull);
    });
  });
}

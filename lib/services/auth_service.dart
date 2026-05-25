import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lazy: GoogleSignIn baru dibuat saat benar-benar dipakai (login Google).
  // Membuatnya di konstruktor memicu inisialisasi google_sign_in yang di web
  // meng-assert "client ID" dan membuat LoginScreen crash. Dengan lazy, login
  // email/password tetap jalan tanpa konfigurasi Google di web.
  GoogleSignIn? _googleSignInInstance;
  GoogleSignIn get _googleSignIn => _googleSignInInstance ??= GoogleSignIn();

  // LOGIN EMAIL & PASSWORD
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      if (kDebugMode) debugPrint("Error Login: $e");
      return null;
    }
  }

  // REGISTER EMAIL & PASSWORD (opsional set displayName)
  Future<User?> register(String email, String password, {String? name}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (name != null && name.trim().isNotEmpty) {
        await result.user?.updateDisplayName(name.trim());
        await result.user?.reload();
      }
      return _auth.currentUser ?? result.user;
    } catch (e) {
      if (kDebugMode) debugPrint("Error Register: $e");
      return null;
    }
  }

  // LOGIN WITH GOOGLE (DIPERBAIKI AGAR TIDAK NYANGKUT)
  Future<User?> loginWithGoogle() async {
    try {
      // Tambahkan ini supaya selalu muncul pilihan akun Google
      await _googleSignIn.signOut(); 
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      if (kDebugMode) debugPrint("Error Google Login: $e");
      return null;
    }
  }

  // GANTI PASSWORD (reauth dulu agar tidak kena requires-recent-login).
  // Mengembalikan null bila sukses, atau pesan error bila gagal.
  Future<String?> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) return 'Anda belum login';

    final email = user.email;
    final hasPassword = user.providerData.any((p) => p.providerId == 'password');
    if (email == null || !hasPassword) {
      return 'Akun Google tidak dapat mengganti password';
    }

    try {
      final cred = EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) debugPrint("Error changePassword: ${e.code}");
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'Password lama salah';
        case 'weak-password':
          return 'Password baru terlalu lemah';
        case 'requires-recent-login':
          return 'Silakan login ulang lalu coba lagi';
        default:
          return 'Gagal mengganti password';
      }
    } catch (e) {
      if (kDebugMode) debugPrint("Error changePassword: $e");
      return 'Gagal mengganti password';
    }
  }

  // LOGOUT
  Future<void> logout() async {
    // Hanya sign-out Google bila instance memang sudah dibuat (pernah login Google),
    // supaya logout di web tidak ikut memicu inisialisasi google_sign_in.
    await _googleSignInInstance?.signOut();
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
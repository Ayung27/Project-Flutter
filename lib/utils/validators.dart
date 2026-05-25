// Validasi input form yang dipakai bersama di layar auth.
// Mengembalikan pesan error (String) bila tidak valid, atau null bila valid.

String? emailError(String email) {
  if (email.isEmpty) return 'Email harus diisi';
  final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
  if (!regex.hasMatch(email)) return 'Format email tidak valid';
  return null;
}

String? passwordError(String password) {
  if (password.isEmpty) return 'Password harus diisi';
  if (password.length < 6) return 'Password minimal 6 karakter';
  return null;
}

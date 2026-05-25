import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final AuthService auth = AuthService();

  bool _isLoading = false;

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (name.isEmpty) {
      _showSnackBar("Nama harus diisi");
      return;
    }
    final eErr = emailError(email);
    if (eErr != null) {
      _showSnackBar(eErr);
      return;
    }
    final pErr = passwordError(password);
    if (pErr != null) {
      _showSnackBar(pErr);
      return;
    }
    if (password != confirm) {
      _showSnackBar("Konfirmasi password tidak cocok");
      return;
    }

    setState(() => _isLoading = true);
    final user = await auth.register(email, password, name: name);
    setState(() => _isLoading = false);

    if (user != null) {
      _showSnackBar("Register berhasil! Silakan login.");
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      _showSnackBar("Email sudah terdaftar atau registrasi gagal.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Daftar Akun", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _field(nameController, "Nama Lengkap"),
                const SizedBox(height: 16),
                _field(emailController, "Email", keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _field(passwordController, "Password", obscure: true),
                const SizedBox(height: 16),
                _field(confirmController, "Konfirmasi Password", obscure: true),
                const SizedBox(height: 24),
                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.green)
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Daftar", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint,
      {bool obscure = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

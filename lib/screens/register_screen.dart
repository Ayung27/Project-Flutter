import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

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
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;

    setState(() {
      _nameError = name.isEmpty ? 'Nama harus diisi' : null;
      _emailError = emailError(email);
      _passwordError = passwordError(password);
      _confirmError = password != confirm ? 'Konfirmasi password tidak cocok' : null;
    });

    if (_nameError != null || _emailError != null || _passwordError != null || _confirmError != null) {
      return;
    }

    setState(() => _isLoading = true);
    final user = await auth.register(email, password, name: name);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      _showSnackBar("Register berhasil! Silakan login.");
      Navigator.pop(context);
    } else {
      _showSnackBar("Email sudah terdaftar atau registrasi gagal.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: ConstrainedBox(
              // Batasi lebar di web/desktop agar tidak melebar.
              constraints: const BoxConstraints(maxWidth: 420),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOut,
                builder: (context, t, child) => Opacity(
                  opacity: t,
                  child: Transform.translate(offset: Offset(0, (1 - t) * 16), child: child),
                ),
                child: _buildForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header premium
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
          child: const Icon(Icons.restaurant_menu, color: AppColors.primary, size: 36),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          "Buat Akun Baru",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          "Daftar untuk mulai memesan makanan favoritmu",
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),

        AuthTextField(
          controller: nameController,
          label: "Nama Lengkap",
          icon: Icons.person_outline,
          errorText: _nameError,
          onChanged: (_) {
            if (_nameError != null) setState(() => _nameError = null);
          },
          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          controller: emailController,
          label: "Email",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
          onChanged: (_) {
            if (_emailError != null) setState(() => _emailError = null);
          },
          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          controller: passwordController,
          label: "Password",
          icon: Icons.lock_outline,
          isPassword: true,
          errorText: _passwordError,
          onChanged: (_) {
            if (_passwordError != null) setState(() => _passwordError = null);
          },
          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          controller: confirmController,
          label: "Konfirmasi Password",
          icon: Icons.lock_outline,
          isPassword: true,
          textInputAction: TextInputAction.done,
          errorText: _confirmError,
          onChanged: (_) {
            if (_confirmError != null) setState(() => _confirmError = null);
          },
          onSubmitted: (_) => register(),
        ),
        const SizedBox(height: AppSpacing.xl),

        PrimaryButton(label: "Daftar", onPressed: register, loading: _isLoading),
        const SizedBox(height: AppSpacing.md),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sudah punya akun? ", style: TextStyle(color: AppColors.textSecondary)),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                "Masuk",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

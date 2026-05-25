import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_text_field.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService auth = AuthService();

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // 🔐 LOGIN EMAIL & PASSWORD
  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    setState(() {
      _emailError = emailError(email);
      // Login tidak memaksa panjang minimum (password akun bisa lama).
      _passwordError = password.isEmpty ? 'Password harus diisi' : null;
    });
    if (_emailError != null || _passwordError != null) return;

    setState(() => _isLoading = true);
    final user = await auth.login(email, password);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackBar('Login gagal. Cek email/password Anda.');
    }
  }

  // 🔵 LOGIN WITH GOOGLE (logic tidak diubah)
  void loginGoogle() async {
    setState(() => _isLoading = true);
    final user = await auth.loginWithGoogle();
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackBar('Login Google dibatalkan atau gagal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: ConstrainedBox(
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
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
          child: const Icon(Icons.restaurant_menu, color: AppColors.primary, size: 36),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          "Selamat Datang 👋",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.xs),
        const Text(
          "Masuk untuk mulai memesan makanan favoritmu",
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),

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
          textInputAction: TextInputAction.done,
          errorText: _passwordError,
          onChanged: (_) {
            if (_passwordError != null) setState(() => _passwordError = null);
          },
          onSubmitted: (_) => login(),
        ),
        const SizedBox(height: AppSpacing.xl),

        PrimaryButton(label: "Masuk", onPressed: login, loading: _isLoading),
        const SizedBox(height: AppSpacing.md),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Belum punya akun? ", style: TextStyle(color: AppColors.textSecondary)),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/register'),
              child: const Text(
                "Daftar",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.border)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text("ATAU", style: TextStyle(color: AppColors.textSecondary)),
            ),
            Expanded(child: Divider(color: AppColors.border)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Google sign-in — logika tidak diubah, hanya layout disamakan.
        OutlinedButton.icon(
          onPressed: _isLoading ? null : loginGoogle,
          icon: Image.asset(
            'assets/images/google_logo.png',
            height: 22,
            width: 22,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.account_circle, color: Colors.blue, size: 22),
          ),
          label: const Text(
            "Login with Google",
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
        ),
      ],
    );
  }
}

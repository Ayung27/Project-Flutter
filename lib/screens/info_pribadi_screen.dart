import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../utils/validators.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_title.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class InfoPribadiScreen extends StatefulWidget {
  const InfoPribadiScreen({super.key});

  @override
  State<InfoPribadiScreen> createState() => _InfoPribadiScreenState();
}

class _InfoPribadiScreenState extends State<InfoPribadiScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late String _initialName;

  bool isEditing = false;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _initialName = user?.displayName ?? user?.email?.split('@')[0] ?? "";
    _nameController = TextEditingController(text: _initialName);
    _phoneController = TextEditingController(text: "081234567890");
    _emailController = TextEditingController(text: user?.email ?? "-");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _startEdit() => setState(() => isEditing = true);

  void _cancelEdit() {
    setState(() {
      _nameController.text = _initialName; // batalkan perubahan
      _nameError = null;
      isEditing = false;
    });
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = 'Nama harus diisi');
      return;
    }
    _updateProfile();
  }

  Future<void> _updateProfile() async {
    try {
      await user?.updateDisplayName(_nameController.text.trim());
      await user?.reload();
      _initialName = _nameController.text.trim();
      setState(() => isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui: $e")),
        );
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Akun?"),
        content: const Text("Semua data kamu akan hilang permanen. Yakin?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await user?.delete();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Harap Login ulang sebelum hapus akun: $e")),
                  );
                }
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Ganti Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Lama"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Baru"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(dialogContext);

              final pErr = passwordError(newCtrl.text);
              if (pErr != null) {
                messenger.showSnackBar(SnackBar(content: Text(pErr)));
                return;
              }
              final error = await _authService.changePassword(currentCtrl.text, newCtrl.text);
              navigator.pop();
              messenger.showSnackBar(
                SnackBar(
                  content: Text(error ?? "Password berhasil diganti"),
                  backgroundColor: error == null ? AppColors.primary : Colors.red,
                ),
              );
            },
            child: const Text("Simpan", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL ?? "";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Informasi Pribadi", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: isEditing ? _cancelEdit : _startEdit,
            child: Text(
              isEditing ? "Batal" : "Edit",
              style: TextStyle(
                color: isEditing ? AppColors.error : AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header profil
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primarySoft,
                    backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                    child: photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 45, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _initialName.isEmpty ? "Pengguna" : _initialName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? "-",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            const SectionTitle("Detail Akun"),
            const SizedBox(height: AppSpacing.md),

            AuthTextField(
              controller: _nameController,
              label: "Nama Lengkap",
              icon: Icons.person_outline,
              enabled: isEditing,
              errorText: _nameError,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AuthTextField(
              controller: _phoneController,
              label: "Nomor Telepon",
              icon: Icons.phone_android_outlined,
              enabled: isEditing,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthTextField(
              controller: _emailController,
              label: "Alamat Email",
              icon: Icons.email_outlined,
              enabled: false, // email tidak dapat diubah dari sini
            ),
            const SizedBox(height: AppSpacing.md),

            // User ID (tap untuk salin)
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: () {
                Clipboard.setData(ClipboardData(text: user?.uid ?? ""));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User ID disalin!"), behavior: SnackBarBehavior.floating),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fingerprint, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("User ID", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            user?.uid ?? "-",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.copy, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
            const SectionTitle("Pengaturan Akun"),
            const SizedBox(height: AppSpacing.sm),

            ListTile(
              onTap: _showChangePasswordDialog,
              leading: const Icon(Icons.lock_outline, color: Colors.blue),
              title: const Text("Ganti Password"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
              leading: const Icon(Icons.logout, color: Colors.orange),
              title: const Text("Keluar dari Akun"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              contentPadding: EdgeInsets.zero,
            ),
            const Divider(),
            ListTile(
              onTap: _showDeleteDialog,
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text("Hapus Akun Permanen", style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      bottomNavigationBar: isEditing
          ? Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(color: AppColors.shadow, blurRadius: 15, offset: const Offset(0, -5)),
                ],
              ),
              child: SafeArea(
                child: PrimaryButton(label: "Simpan Perubahan", onPressed: _save),
              ),
            )
          : null,
    );
  }
}

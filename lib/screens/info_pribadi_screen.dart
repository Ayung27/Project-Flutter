import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../utils/validators.dart';

class InfoPribadiScreen extends StatefulWidget {
  const InfoPribadiScreen({super.key});

  @override
  State<InfoPribadiScreen> createState() => _InfoPribadiScreenState();
}

class _InfoPribadiScreenState extends State<InfoPribadiScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService _authService = AuthService();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    String initialName = user?.displayName ?? user?.email?.split('@')[0] ?? "";
    _nameController = TextEditingController(text: initialName);
    _phoneController = TextEditingController(text: "081234567890"); 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // --- FUNGSI DIALOG HAPUS AKUN (DITARUH DI SINI SUPAYA TIDAK ERROR) ---
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
                  backgroundColor: error == null ? const Color(0xFF4CAF50) : Colors.red,
                ),
              );
            },
            child: const Text("Simpan", style: TextStyle(color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfile() async {
    try {
      await user?.updateDisplayName(_nameController.text);
      await user?.reload(); 
      setState(() {
        isEditing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!"), behavior: SnackBarBehavior.floating),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Informasi Pribadi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (isEditing) {
                _updateProfile();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
            child: Text(
              isEditing ? "Batal" : "Edit",
              style: TextStyle(color: isEditing ? Colors.red : const Color(0xFF4CAF50), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Detail Akun", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            _buildEditableTile("Nama Lengkap", _nameController, Icons.person_outline, isEditing),
            _buildEditableTile("Nomor Telepon", _phoneController, Icons.phone_android_outlined, isEditing, isPhone: true),
            _buildStaticTile("Alamat Email", user?.email ?? "-", Icons.email_outlined),

            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: user?.uid ?? ""));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User ID disalin!")));
              },
              child: _buildStaticTile("User ID", user?.uid ?? "-", Icons.fingerprint),
            ),

            const SizedBox(height: 30),
            const Text("Pengaturan Akun", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 10),

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
              onTap: () => _showDeleteDialog(),
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
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => _updateProfile(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        : null,
    );
  }

  Widget _buildEditableTile(String label, TextEditingController controller, IconData icon, bool enabled, {bool isPhone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: enabled ? Colors.green.withValues(alpha: 0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: enabled ? Colors.green : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                enabled 
                  ? TextField(
                      controller: controller,
                      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
                      inputFormatters: isPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
                      decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(controller.text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
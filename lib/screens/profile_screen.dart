import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Ambil data user terbaru dari Firebase
    final User? user = FirebaseAuth.instance.currentUser;

    // 2. Logika penentuan nama agar sinkron dengan Info Pribadi
    String rawName = user?.displayName ?? 
                     user?.email?.split('@')[0] ?? 
                     "Pengguna";
    
    // Membuat huruf pertama menjadi Kapital
    String name = rawName.isNotEmpty 
        ? rawName[0].toUpperCase() + rawName.substring(1) 
        : "Pengguna";
    
    String email = user?.email ?? "email@tidakditemukan.com";
    String photoUrl = user?.photoURL ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        // Leading sekarang sudah benar di dalam AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  // Avatar Profil Dinamis
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: photoUrl.isNotEmpty 
                        ? NetworkImage(photoUrl) 
                        : null,
                    child: photoUrl.isEmpty 
                        ? const Icon(Icons.person, size: 55, color: Colors.grey) 
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // NAMA DINAMIS
                  Text(
                    name, 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                  // EMAIL DINAMIS
                  Text(
                    email, 
                    style: const TextStyle(color: Colors.grey)
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // 1. INFORMASI PRIBADI (Ditambah async/await agar langsung refresh)
            _buildMenuItem(Icons.person_outlined, "Informasi Pribadi", () async {
              await Navigator.pushNamed(context, '/info_pribadi');
              setState(() {}); // Refresh nama setelah kembali dari edit
            }),

            // 2. PESANAN SAYA
            _buildMenuItem(Icons.shopping_bag_outlined, "Pesanan Saya", () {
              Navigator.pushNamed(context, '/pesanan-saya'); 
            }),

            // 3. ALAMAT PENGIRIMAN
            _buildMenuItem(Icons.location_on_outlined, "Alamat Pengiriman", () {
              Navigator.pushNamed(context, '/alamat'); 
            }),

            // 4. METODE PEMBAYARAN
            _buildMenuItem(Icons.payment_outlined, "Metode Pembayaran", () {
              Navigator.pushNamed(context, '/pembayaran'); 
            }),
            
            const Divider(height: 40, indent: 20, endIndent: 20),

            // TOMBOL KELUAR
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Keluar", 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF4CAF50)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap, 
    );
  }
}
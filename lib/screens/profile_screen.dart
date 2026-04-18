import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
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
                  const CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"),
                  ),
                  const SizedBox(height: 16),
                  const Text("Nasywan dan Bahrul", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("nasywan.dan.bahrul@student.uinbanten.ac.id", 
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // 1. INFORMASI PRIBADI
            _buildMenuItem(Icons.person_outlined, "Informasi Pribadi", () {
              Navigator.pushNamed(context, '/info_pribadi'); 
            }),

            // 2. PESANAN SAYA (Sudah diarahkan ke riwayat pesanan)
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

            // TOMBOL KELUAR (Sudah diperbaiki rutenya ke /login)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Keluar", 
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
              ),
              onTap: () {
                // Navigator ini akan menghapus semua history dan balik ke login
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi Helper untuk membuat item menu agar kode rapi
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
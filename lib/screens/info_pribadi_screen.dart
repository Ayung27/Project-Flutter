import 'package:flutter/material.dart';

class InfoPribadiScreen extends StatelessWidget {
  const InfoPribadiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Informasi Pribadi",
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PROFIL 1: Bahrul Ulumudin ---
            const Text(
              "Profil Mahasiswa 1",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4CAF50)),
            ),
            const SizedBox(height: 10),
            _buildInfoTile("Nama Lengkap", "Bahrul Ulumudin"),
            _buildInfoTile("NIM", "241730090"),
            _buildInfoTile("Program Studi", "Informatika (4 C)"),
            _buildInfoTile("Universitas", "UIN Sultan Maulana Hasanuddin Banten"),
            _buildInfoTile("Email", "241730090.bahrululumudin@uinbanten.ac.id"),

            const SizedBox(height: 30),
            const Divider(thickness: 2),
            const SizedBox(height: 20),

            // --- PROFIL 2: Muhammad Nasywan Amin ---
            const Text(
              "Profil Mahasiswa 2",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4CAF50)),
            ),
            const SizedBox(height: 10),
            _buildInfoTile("Nama Lengkap", "Muhammad Nasywan Amin"),
            _buildInfoTile("NIM", "241730084"),
            _buildInfoTile("Program Studi", "Informatika (4 C)"),
            _buildInfoTile("Universitas", "UIN Sultan Maulana Hasanuddin Banten"),
            _buildInfoTile("Email", "awan.mahasiswa@uinbanten.ac.id"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Fungsi helper untuk membuat baris informasi
  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
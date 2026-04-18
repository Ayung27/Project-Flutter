import 'package:flutter/material.dart';

class AlamatFormScreen extends StatefulWidget {
  final String? title;
  final String? initialNama;   // Tambahkan ini untuk menampung nama lama
  final String? initialDetail; // Tambahkan ini untuk menampung detail lama

  const AlamatFormScreen({
    super.key, 
    this.title, 
    this.initialNama, 
    this.initialDetail,
  });

  @override
  State<AlamatFormScreen> createState() => _AlamatFormScreenState();
}

class _AlamatFormScreenState extends State<AlamatFormScreen> {
  late TextEditingController _namaController;
  late TextEditingController _detailController;

  @override
  void initState() {
    super.initState();
    // Mengisi controller dengan data awal jika sedang mode "Edit"
    _namaController = TextEditingController(text: widget.initialNama ?? "");
    _detailController = TextEditingController(text: widget.initialDetail ?? "");
  }

  @override
  void dispose() {
    _namaController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title ?? "Alamat", 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: "Nama Tempat (Contoh: Kosan)",
                hintText: "Masukkan nama tempat",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Alamat Lengkap",
                hintText: "Masukkan alamat lengkap...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_namaController.text.isNotEmpty && _detailController.text.isNotEmpty) {
                    // Mengembalikan data ke halaman sebelumnya
                    Navigator.pop(context, {
                      "nama": _namaController.text,
                      "detail": _detailController.text,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Isi semua data dulu ya, Bahrul! 😊"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text(
                  "Simpan Alamat", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
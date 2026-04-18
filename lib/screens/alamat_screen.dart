import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/alamat_provider.dart'; // Import provider baru
import 'alamat_from_screen.dart';

class AlamatScreen extends StatelessWidget {
  const AlamatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari AlamatProvider
    final alamatProv = Provider.of<AlamatProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pilih Alamat", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alamatProv.daftarAlamat.length,
              itemBuilder: (context, index) {
                final item = alamatProv.daftarAlamat[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade50,
                      child: Icon(
                        item['icon'] == 'home' ? Icons.home : (item['icon'] == 'school' ? Icons.school : Icons.location_on),
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                    title: Text(item['label']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['detail']!),
                    // IKON HAPUS
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        // Munculkan konfirmasi hapus
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Hapus Alamat?"),
                            content: const Text("Apakah kamu yakin ingin menghapus alamat ini?"),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                              TextButton(
                                onPressed: () {
                                  alamatProv.hapusAlamat(index);
                                  Navigator.pop(context);
                                },
                                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () => Navigator.pop(context, item['detail']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final hasil = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AlamatFormScreen(title: "Tambah Alamat Baru")),
                  );

                  if (hasil != null && hasil is Map) {
                    alamatProv.tambahAlamat(hasil['nama'], hasil['detail']);
                  }
                },
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text("Tambah Alamat Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4CAF50),
                  side: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
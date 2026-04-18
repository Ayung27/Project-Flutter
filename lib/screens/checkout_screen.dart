import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_providers.dart'; 
import 'pembayaran_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String metodePembayaran = "COD"; 
  String alamatSaatIni = "Jl. Contoh No.123, Serang, Banten";

  @override
  Widget build(BuildContext context) {
    // Memanggil CartProvider
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;
    
    int subtotal = cartProvider.totalBayar; 
    int ongkir = items.isEmpty ? 0 : 15000;
    int totalHarga = subtotal + ongkir;

    String formatRupiah(int number) {
      return "Rp ${number.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Alamat Pengiriman"),
            const SizedBox(height: 12),
            
            GestureDetector(
              onTap: () async {
                // Navigasi ke alamat screen dan menunggu return data string
                final alamatBaru = await Navigator.pushNamed(context, '/alamat');
                
                if (alamatBaru != null && alamatBaru is String) {
                  setState(() {
                    alamatSaatIni = alamatBaru;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.04),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Color(0xFF4CAF50)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Lokasi Terpilih",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            alamatSaatIni,
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          )
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_outlined, color: Color(0xFF4CAF50)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Ringkasan Pesanan"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Total Item", "${items.fold(0, (sum, item) => sum + (item['quantity'] as int))} Item"),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Subtotal", formatRupiah(subtotal)),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Ongkir", formatRupiah(ongkir)),
                  const Divider(height: 32, color: Colors.black12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Harga",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        formatRupiah(totalHarga),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Metode Pembayaran"),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final hasilPilihan = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PembayaranScreen(currentMethod: metodePembayaran),
                  ),
                );

                if (hasilPilihan != null) {
                  setState(() {
                    metodePembayaran = hasilPilihan.toString();
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF4CAF50),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.payment, color: Color(0xFF4CAF50)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        metodePembayaran,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: items.isEmpty ? null : () { 
                // --- PERBAIKAN DI SINI ---
                // 1. Simpan ke riwayat pesanan dulu
                cartProvider.addOrder(totalHarga); 

                // 2. Tampilkan snackbar keberhasilan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Pesanan berhasil dibuat! 🎉"),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                
                // 3. Pindah ke Home setelah delay singkat
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Pesan Sekarang 🚀",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_providers.dart';
import '../utils/currency.dart';
import '../widgets/section_title.dart';
import '../widgets/primary_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'pembayaran_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String metodePembayaran = "COD";
  String alamatSaatIni = "Jl. Contoh No.123, Serang, Banten";
  final voucherController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void dispose() {
    voucherController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Memanggil CartProvider
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;
    
    int subtotal = cartProvider.totalBayar;
    int ongkir = items.isEmpty ? 0 : 15000;
    int discount = cartProvider.discount;
    int totalHarga = subtotal + ongkir - discount;

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
            const SectionTitle("Alamat Pengiriman"),
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
                      color: Colors.grey.withValues(alpha: 0.04),
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

            const SectionTitle("Ringkasan Pesanan"),
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
                  _buildSummaryRow("Total Item", "${items.fold(0, (sum, item) => sum + item.quantity)} Item"),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Subtotal", formatRupiah(subtotal)),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Ongkir", formatRupiah(ongkir)),
                  if (discount > 0) ...[
                    const SizedBox(height: 8),
                    _buildSummaryRow("Diskon Voucher", "-${formatRupiah(discount)}"),
                  ],
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

            const SectionTitle("Voucher Diskon"),
            const SizedBox(height: 12),
            _buildVoucherSection(cartProvider),

            const SizedBox(height: 24),

            const SectionTitle("Metode Pembayaran"),
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

            const SizedBox(height: 24),
            const SectionTitle("Catatan untuk Pesanan"),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Contoh: jangan pedas, saus dipisah...",
                filled: true,
                fillColor: AppColors.fieldFill,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
              color: Colors.grey.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: PrimaryButton(
            label: "Pesan Sekarang",
            onPressed: items.isEmpty
                ? null
                : () {
                    // 1. Simpan ke riwayat pesanan dulu
                    cartProvider.addOrder(totalHarga, notes: notesController.text.trim());

                    // 2. Tampilkan snackbar keberhasilan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pesanan berhasil dibuat"),
                        backgroundColor: Color(0xFF4CAF50),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );

                    // 3. Pindah ke Home setelah delay singkat
                    final navigator = Navigator.of(context);
                    Future.delayed(const Duration(seconds: 1), () {
                      navigator.pushNamedAndRemoveUntil('/home', (route) => false);
                    });
                  },
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherSection(CartProvider cartProvider) {
    final applied = cartProvider.appliedVoucher;
    if (applied != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4CAF50)),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer, color: Color(0xFF4CAF50)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(applied.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(applied.label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            TextButton(
              onPressed: () => cartProvider.removeVoucher(),
              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: voucherController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: "Masukkan kode voucher",
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () {
              final err = cartProvider.applyVoucher(voucherController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(err ?? "Voucher diterapkan"),
                  backgroundColor: err == null ? const Color(0xFF4CAF50) : Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Pakai", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
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
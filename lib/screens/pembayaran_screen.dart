import 'package:flutter/material.dart';

class PembayaranScreen extends StatefulWidget {
  // Tambahkan variabel untuk menerima pilihan saat ini agar tidak ter-reset
  final String? currentMethod;
  const PembayaranScreen({super.key, this.currentMethod});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  // Gunakan data dari halaman sebelumnya jika ada, jika tidak default ke 'COD'
  late String selectedMethod;

  @override
  void initState() {
    super.initState();
    selectedMethod = widget.currentMethod ?? "COD";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          RadioGroup<String>(
            groupValue: selectedMethod,
            onChanged: (val) {
              setState(() {
                selectedMethod = val ?? selectedMethod;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPaymentOption("COD", "Bayar di Tempat", Icons.money),
                _buildPaymentOption("Transfer Bank", "Transfer via ATM/Mobile Banking", Icons.account_balance),
                _buildPaymentOption("E-Wallet", "OVO, Dana, GoPay", Icons.account_balance_wallet),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // KIRIM PILIHAN BALIK KE HALAMAN CHECKOUT
                  Navigator.pop(context, selectedMethod);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Pilih Metode Ini", style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String desc, IconData icon) {
    return RadioListTile<String>(
      value: value,
      title: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(desc),
      secondary: Icon(icon, color: Colors.green),
    );
  }
}
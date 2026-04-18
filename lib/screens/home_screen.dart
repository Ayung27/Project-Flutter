import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_providers.dart';
import 'home_content.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void tambahKeKeranjang(String nama, String harga, String imageUrl) {
    context.read<CartProvider>().addItem({
      "nama": nama,
      "harga": harga,
      "imageUrl": imageUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$nama masuk keranjang! 🛒"),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List halaman yang dipanggil
    final List<Widget> _pages = [
      HomeContent(onAddToCart: tambahKeKeranjang), // Index 0
      const CartScreen(),                          // Index 1
      const ProfileScreen(),                       // Index 2
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
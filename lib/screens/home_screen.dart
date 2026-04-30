import 'cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'profile_screen.dart';


import '../providers/cart_providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Navigasi Bottom Bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman
    final List<Widget> _pages = [
  const HomeContent(),    // Index 0 (Home)
  const CartScreen(),     // Index 1 (Cart) - sesuaikan nama class-nya
  const ProfileScreen(),  // Index 2 (Profile) - TAMBAHKAN INI
];

    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'assets/images/special_30_%.png',
      'assets/images/diskon_50_%.png',
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lokasi
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 18),
                  SizedBox(width: 5),
                  Text("Kronjo, Banten", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Halo, Ayung 👋", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari makanan...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Banner Slide
            CarouselSlider(
              options: CarouselOptions(
                height: 170.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                autoPlayCurve: Curves.easeInOut,
              ),
              items: bannerImages.map((path) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: AssetImage(path), fit: BoxFit.fill),
                  ),
                );
              }).toList(),
            ),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Rekomendasi Untukmu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // LIST MAKANAN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _foodItem(context, "Nasi Goreng Spesial", "Rp 25.000", "4.8", 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=200'),
                  _foodItem(context, "Ayam Geprek Matah", "Rp 20.000", "4.8", 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=200'),
                  _foodItem(context, "Burger Beef", "Rp 35.000", "4.9", 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=200'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodItem(BuildContext context, String nama, String harga, String rating, String img) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              img, width: 80, height: 80, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.fastfood)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(" $rating "),
                    const SizedBox(width: 10),
                    Text(harga, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          // TOMBOL TAMBAH KE KERANJANG
          IconButton(
            onPressed: () {
              // Memanggil fungsi addItem dari CartProvider kamu
              Provider.of<CartProvider>(context, listen: false).addItem({
                'nama': nama,
                'harga': harga,
                'gambar': img,
              });

              // Notifikasi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$nama ditambah ke keranjang!"),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.add_circle, color: Colors.green, size: 35),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Import file lokal project
import 'cart_screen.dart';
import 'profile_screen.dart';
import '../providers/cart_providers.dart';
import '../models/product.dart';
import '../utils/currency.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Fungsi navigasi menu bawah
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Daftar halaman yang akan ditampilkan
    final List<Widget> pages = [
      const HomeContent(),   // Halaman Utama dengan Search & GPS
      const CartScreen(),    // Halaman Keranjang
      const ProfileScreen(), // Halaman Profil
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selectedIndex], // Menampilkan halaman sesuai index menu
      

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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

// --- BAGIAN KONTEN HOME (DENGAN GPS & SEARCH) ---
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String userLocation = "Mencari lokasi...";
  List<Product> displayedFoods = [];

  final List<Product> allFoods = const [
    Product(name: "Nasi Goreng Spesial", price: 25000, rating: 4.8, imageUrl: "https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=200"),
    Product(name: "Ayam Geprek Matah", price: 20000, rating: 4.8, imageUrl: "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=200"),
    Product(name: "Burger Beef", price: 35000, rating: 4.9, imageUrl: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=200", available: false),
  ];

  @override
  void initState() {
    super.initState();
    displayedFoods = allFoods;
    _determinePosition();
  }

  // Fungsi GPS Otomatis
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => userLocation = "GPS Matikan");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => userLocation = "Izin Ditolak");
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      if (mounted) {
        setState(() {
          userLocation = "${place.subLocality}, ${place.locality}";
        });
      }
    } catch (e) {
      if (mounted) setState(() => userLocation = "Lokasi Tidak Dikenal");
    }
  }

  // Fungsi Search
  void _runFilter(String enteredKeyword) {
    List<Product> results = [];
    if (enteredKeyword.isEmpty) {
      results = allFoods;
    } else {
      results = allFoods
          .where((food) => food.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      displayedFoods = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String rawName = user?.displayName ?? user?.email?.split('@')[0] ?? "Pengguna";
    String name = rawName.isNotEmpty ? rawName[0].toUpperCase() + rawName.substring(1) : "Pengguna";

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Lokasi Otomatis
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 18),
                  const SizedBox(width: 5),
                  Text(userLocation, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            // Halo Nama User Otomatis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Halo, $name 👋", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),

            // Search Bar Aktif
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  onChanged: (value) => _runFilter(value),
                  decoration: const InputDecoration(
                    hintText: "Cari makanan...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            _buildCarousel(),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Rekomendasi Untukmu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // List Makanan Terfilter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: displayedFoods.isNotEmpty
                  ? Column(
                      children: displayedFoods.map((food) => _buildFoodItem(food)).toList(),
                    )
                  : const Center(child: Text("Makanan tidak ditemukan")),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItem(Product food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color:Colors.green.withValues(alpha: 0.05), blurRadius: 10)]),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(food.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    if (!food.available) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                        child: const Text("Habis", style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text(" ${food.rating} "),
                    const SizedBox(width: 10),
                    Text(formatRupiah(food.price), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
          onPressed: food.available ? () {
            // 1. Tambah item ke provider
            Provider.of<CartProvider>(context, listen: false).addItem(food);

            // 2. Munculkan SnackBar Hijau
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${food.name} ditambah",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.green, // Mengubah warna jadi hijau
                behavior: SnackBarBehavior.floating, // Membuat snackbar melayang
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Membuat sudut melengkung 
                ),
                duration: const Duration(seconds: 1),
                margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20), // Jarak dari pinggir
              ),
            );
          } : null,
          icon: Icon(Icons.add_circle, color: food.available ? Colors.green : Colors.grey, size: 35),
        ),
      ],
    ),
  );
}

  Widget _buildCarousel() {
    final List<String> bannerImages = ['assets/images/special_30_%.png', 'assets/images/diskon_50_%.png'];
    return CarouselSlider(
      options: CarouselOptions(height: 170.0, enlargeCenterPage: true, autoPlay: true, viewportFraction: 0.9),
      items: bannerImages.map((path) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(path), fit: BoxFit.fill),
        ),
      )).toList(),
    );
  }
}
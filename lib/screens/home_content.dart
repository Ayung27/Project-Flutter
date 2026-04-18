import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  final Function(String, String, String) onAddToCart;

  const HomeContent({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Lokasi & Foto Profil)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📍 Lokasi Saat Ini",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Serang, Banten",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),

            // Greeting
            const Text(
              "Halo, Nasywan danBahrul 👋",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 2. Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari makanan favorit...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Promo Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🔥 Diskon 50%",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "khusus pengguna baru!",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.percent, color: Colors.white, size: 40)
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              "Rekomendasi Untukmu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 5. Food Card List
            // 5. Food Card List (Sekarang ada 5 menu spesial!)
_buildFoodCard(
  "Nasi Goreng Spesial", 
  "Rp 25.000", 
  "https://images.unsplash.com/photo-1512058564366-18510be2db19?w=800", 
  4.8
),
        _buildFoodCard(
          "Ayam Geprek Matah", 
          "Rp 20.000", 
          "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=800", 
          4.7
        ),
        _buildFoodCard(
          "Burger Beef Rendang", 
          "Rp 45.000", 
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800", 
          4.9
        ),
        _buildFoodCard(
          "Sate Ayam Madura", 
          "Rp 30.000", 
          "https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?w=800", 
          4.6
        ),
        _buildFoodCard(
          "Mie Goreng Jawa", 
          "Rp 18.000", 
          "https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800", 
          4.5
        ),
          ],
        ),
      ),
    );
  }

  // Widget pendukung untuk Card Makanan agar kode tidak menumpuk
  Widget _buildFoodCard(String name, String price, String img, double rate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.network(img, width: 100, height: 100, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(price, style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16), Text(" $rate")]),
                      IconButton(
                        onPressed: () => onAddToCart(name, price, img),
                        icon: const Icon(Icons.add_circle, color: Color(0xFF4CAF50), size: 30),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
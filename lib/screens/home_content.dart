import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  final Function(String, String, String) onAddToCart;
  final String userName;

  const HomeContent({
    super.key,
    required this.onAddToCart,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      "Serang, Banten",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Halo, $userName 👋",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari makanan favorit...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // --- PROMO BANNER ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🔥 Diskon 50%", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 20, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Khusus pengguna baru!", 
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  Icon(Icons.stars, color: Colors.white, size: 45),
                ],
              ),
            ),
          ),

          // --- SECTION TITLE ---
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Rekomendasi Untukmu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // --- LIST MAKANAN ---
          _buildFoodItem(
            "Nasi Goreng Spesial", 
            "25.000", 
            "https://cdn.pixabay.com/photo/2017/06/10/19/29/food-2390505_640.jpg"
          ),
          _buildFoodItem(
            "Ayam Geprek Matah", 
            "20.000", 
            "https://cdn.pixabay.com/photo/2016/11/18/17/42/barbecue-1836000_640.jpg"
          ),
          _buildFoodItem(
            "Burger Beef Rendang", 
            "45.000", 
            "https://cdn.pixabay.com/photo/2016/03/05/19/02/hamburger-1238246_640.jpg"
          ),
          
          const SizedBox(height: 30), // Padding bawah agar tidak mepet navbar
        ],
      ),
    );
  }

  // WIDGET CARD MAKANAN
  Widget _buildFoodItem(String nama, String harga, String imgUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: SizedBox(
          width: 70,
          height: 70,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                );
              },
            ),
          ),
        ),
        title: Text(
          nama, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 14),
              const SizedBox(width: 4),
              const Text("4.8", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(width: 12),
              Text(
                "Rp $harga", 
                style: const TextStyle(
                  color: Colors.green, 
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                )
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.green, size: 35),
          onPressed: () => onAddToCart(nama, harga, imgUrl),
        ),
      ),
    );
  }
}
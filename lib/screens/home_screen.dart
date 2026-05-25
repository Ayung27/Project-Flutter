import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// Import file lokal project
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'favorite_screen.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_providers.dart';
import '../models/product.dart';
import '../data/menu_data.dart';
import '../utils/recommendations.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/food_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeContent(),
      FavoriteScreen(onExplore: () => _onItemTapped(0)),
      CartScreen(onExplore: () => _onItemTapped(0)),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// --- KONTEN HOME (GPS + kategori + search/filter) ---
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String userLocation = "Mencari lokasi...";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = kAllCategory;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Hasil filter gabungan: kategori × kata kunci pencarian.
  List<Product> get _filteredFoods {
    final query = _searchQuery.trim().toLowerCase();
    return kMenu.where((food) {
      final matchCategory =
          _selectedCategory == kAllCategory || food.category == _selectedCategory;
      final matchQuery = query.isEmpty || food.name.toLowerCase().contains(query);
      return matchCategory && matchQuery;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = kAllCategory;
    });
  }

  // GPS otomatis untuk header lokasi
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
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
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

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String rawName = user?.displayName ?? user?.email?.split('@')[0] ?? "Pengguna";
    String name = rawName.isNotEmpty
        ? rawName[0].toUpperCase() + rawName.substring(1)
        : "Pengguna";

    final foods = _filteredFoods;
    final listTitle =
        _selectedCategory == kAllCategory ? "Rekomendasi Untukmu" : _selectedCategory;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header lokasi
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 18),
                  const SizedBox(width: 5),
                  Text(userLocation, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),

            // Salam
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text("Halo, $name 👋",
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),

            // Search bar (realtime + clear)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: AppColors.fieldFill,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Cari makanan favoritmu...",
                    border: InputBorder.none,
                    icon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () =>
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                }),
                          )
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Section kategori (horizontal scroll)
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: kCategories.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) {
                  final cat = kCategories[i];
                  return CategoryChip(
                    category: cat,
                    selected: _selectedCategory == cat.label,
                    onTap: () => setState(() => _selectedCategory = cat.label),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
            _buildCarousel(),

            // Section "Favorit Kamu" (muncul hanya bila ada favorit)
            _buildFavoriteSection(),

            // Section "Pernah Dipesan" (berbasis riwayat order nyata)
            _buildRecentlyOrderedSection(),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(listTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // Daftar menu terfilter / empty state
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: foods.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: EmptyState(
                        icon: Icons.search_off,
                        title: "Menu tidak ditemukan",
                        message: "Coba kata kunci atau kategori lain.",
                        actionLabel: "Reset Filter",
                        onAction: _resetFilters,
                      ),
                    )
                  : Column(
                      children: foods
                          .map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: FoodCard(product: f),
                              ))
                          .toList(),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Section horizontal "Favorit Kamu" — hanya muncul bila ada favorit.
  /// Consumer membatasi rebuild ke section ini saja saat favorit berubah.
  Widget _buildFavoriteSection() {
    return Consumer<FavoritesProvider>(
      builder: (context, fav, _) {
        final favProducts = kMenu.where((p) => fav.isFavorite(p.name)).toList();
        if (favProducts.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text("Favorit Kamu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: favProducts.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) =>
                    SizedBox(width: 300, child: FoodCard(product: favProducts[i])),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Section "Pernah Dipesan" — rekomendasi berbasis riwayat order nyata.
  /// Selector membatasi rebuild ke perubahan jumlah order (bukan tiap cart change).
  Widget _buildRecentlyOrderedSection() {
    return Selector<CartProvider, int>(
      selector: (_, cart) => cart.orders.length,
      builder: (context, _, _) {
        final products = recentlyOrdered(context.read<CartProvider>().orders, kMenu);
        if (products.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text("Pernah Dipesan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) =>
                    SizedBox(width: 300, child: FoodCard(product: products[i])),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCarousel() {
    final List<String> bannerImages = [
      'assets/images/special_30_%.png',
      'assets/images/diskon_50_%.png'
    ];
    return CarouselSlider(
      options: CarouselOptions(
        height: 170.0,
        enlargeCenterPage: true,
        autoPlay: true,
        viewportFraction: 0.9,
      ),
      items: bannerImages
          .map((path) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: AssetImage(path), fit: BoxFit.fill),
                ),
              ))
          .toList(),
    );
  }
}

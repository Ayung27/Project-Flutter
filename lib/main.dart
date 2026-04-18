import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/alamat_screen.dart';
import 'screens/info_pribadi_screen.dart';
import 'screens/pembayaran_screen.dart';
import 'screens/alamat_from_screen.dart';
import 'screens/order_history_screen.dart';

// Import Providers
import 'providers/cart_providers.dart';
import 'providers/alamat_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AlamatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: '/login', 
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/alamat': (context) => const AlamatScreen(),
        '/tambah-alamat': (context) => const AlamatFormScreen(title: "Tambah Alamat Baru"),
        
        // --- PASTIKAN NAMA RUTE INI SAMA PERSIS DENGAN YANG DI PROFILE_SCREEN ---
        '/info_pribadi': (context) => const InfoPribadiScreen(), 
        '/pembayaran': (context) => const PembayaranScreen(currentMethod: 'COD'),
        '/pesanan-saya': (context) => const OrderHistoryScreen(),
      },
    );
  }
}
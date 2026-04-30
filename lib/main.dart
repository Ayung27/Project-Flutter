import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Import Screens
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/cart_screen.dart';
import 'package:food_app/screens/checkout_screen.dart';
import 'package:food_app/screens/profile_screen.dart';
import 'package:food_app/screens/alamat_screen.dart';
import 'package:food_app/screens/info_pribadi_screen.dart';
import 'package:food_app/screens/pembayaran_screen.dart';
import 'package:food_app/screens/alamat_from_screen.dart';
import 'package:food_app/screens/order_history_screen.dart';

// Import Providers
import 'package:food_app/providers/cart_providers.dart';
import 'package:food_app/providers/alamat_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF43A047)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => LoginScreen(), // const dihapus
        '/login': (context) => LoginScreen(), // const dihapus
        '/home': (context) => HomeScreen(), // const dihapus
        '/cart': (context) => const CartScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/alamat': (context) => const AlamatScreen(),
        '/tambah-alamat': (context) => const AlamatFormScreen(title: "Tambah Alamat Baru"),
        '/info_pribadi': (context) => const InfoPribadiScreen(),
        '/pembayaran': (context) => const PembayaranScreen(currentMethod: 'COD'),
        '/pesanan-saya': (context) => const OrderHistoryScreen(),
      },
    );
  }
}
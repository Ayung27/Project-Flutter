import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/services/storage_service.dart';
import 'package:food_app/theme/app_theme.dart';

// Import Screens
import 'package:food_app/screens/login_screen.dart';
import 'package:food_app/screens/register_screen.dart';
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
import 'package:food_app/providers/favorites_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi persistensi lokal sebelum runApp agar data langsung tersedia
  // saat provider dibuat (loading sinkron, tanpa flicker/null).
  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider(storage: storage)..load()),
        ChangeNotifierProvider(create: (_) => AlamatProvider(storage: storage)..load()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(storage: storage)..load()),
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
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: {
        '/': (context) => LoginScreen(), // const dihapus
        '/login': (context) => LoginScreen(), // const dihapus
        '/register': (context) => const RegisterScreen(),
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
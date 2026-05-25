import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/food_category.dart';

/// Sumber data menu & kategori terpusat (statis untuk saat ini).
/// Saat menu menjadi dinamis (API/Firestore), cukup ganti sumber di sini —
/// UI tidak perlu berubah.

/// Label kategori khusus yang menampilkan semua menu.
const String kAllCategory = 'Semua';

const List<FoodCategory> kCategories = [
  FoodCategory(label: kAllCategory, icon: Icons.restaurant_menu),
  FoodCategory(label: 'Makanan', icon: Icons.rice_bowl),
  FoodCategory(label: 'Minuman', icon: Icons.local_drink),
  FoodCategory(label: 'Snack', icon: Icons.fastfood),
  FoodCategory(label: 'Dessert', icon: Icons.icecream),
  FoodCategory(label: 'Burger', icon: Icons.lunch_dining),
  FoodCategory(label: 'Kopi', icon: Icons.coffee),
];

const List<Product> kMenu = [
  Product(name: 'Nasi Goreng Spesial', price: 25000, rating: 4.8, category: 'Makanan', imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=200'),
  Product(name: 'Ayam Geprek Matah', price: 20000, rating: 4.8, category: 'Makanan', imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=200'),
  Product(name: 'Mie Goreng Jawa', price: 18000, rating: 4.6, category: 'Makanan', imageUrl: 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=200'),
  Product(name: 'Es Teh Manis', price: 6000, rating: 4.5, category: 'Minuman', imageUrl: 'https://images.unsplash.com/photo-1499638673689-79a0b5115d87?w=200'),
  Product(name: 'Jus Alpukat', price: 15000, rating: 4.7, category: 'Minuman', imageUrl: 'https://images.unsplash.com/photo-1623065422902-30a2d299bbe4?w=200'),
  Product(name: 'Kentang Goreng', price: 15000, rating: 4.6, category: 'Snack', imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=200'),
  Product(name: 'Pisang Goreng', price: 12000, rating: 4.4, category: 'Snack', imageUrl: 'https://images.unsplash.com/photo-1592151675528-1a0c09dde9b2?w=200'),
  Product(name: 'Es Krim Vanilla', price: 13000, rating: 4.7, category: 'Dessert', imageUrl: 'https://images.unsplash.com/photo-1576506295286-5cda18df43e7?w=200'),
  Product(name: 'Pudding Coklat', price: 14000, rating: 4.6, category: 'Dessert', imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=200'),
  Product(name: 'Burger Beef', price: 35000, rating: 4.9, category: 'Burger', available: false, imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=200'),
  Product(name: 'Cheese Burger', price: 32000, rating: 4.8, category: 'Burger', imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200'),
  Product(name: 'Kopi Susu Gula Aren', price: 18000, rating: 4.9, category: 'Kopi', imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200'),
  Product(name: 'Americano', price: 16000, rating: 4.5, category: 'Kopi', imageUrl: 'https://images.unsplash.com/photo-1551030173-122aabc4489c?w=200'),
];

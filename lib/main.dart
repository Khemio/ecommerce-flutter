// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shop_provider.dart';
import 'screens/home_screen.dart';
import 'app_theme.dart';

void main() {
  runApp(
    // 1. Wrap the entire application in your dynamic shop provider state
    ChangeNotifierProvider(
      create: (context) => ShopProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azkomoly Demo App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.brandTheme,
      home: const HomeScreen(),
    );
  }
}

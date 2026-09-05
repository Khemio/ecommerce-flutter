import 'package:flutter/material.dart';

import 'package:flutter_app/app_localizations.dart';
import 'package:flutter_app/core/providers/shop_provider.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_app/features/profile/profile_screen.dart';
import 'home/home_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  
  // Clean viewport cache matrix
  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex, // Preserves the scroll position of screens when switching tabs!
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: const Color(0xFF5A24B3), // Brand Violet
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), 
              activeIcon: Icon(Icons.explore), 
              label: AppLocalizations.translate('explore_tab', shopProvider.appLanguage),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), 
              activeIcon: Icon(Icons.shopping_bag), 
              label: AppLocalizations.translate('bag_tab', shopProvider.appLanguage),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), 
              activeIcon: Icon(Icons.person), 
              label: AppLocalizations.translate('profile_tab', shopProvider.appLanguage),
            ),
          ],
        ),
      ),
    );
  }
}

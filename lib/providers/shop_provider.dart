import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';
import '../models/user_profile.dart';
import '../app_config.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

// TODO: Convert _orderHistory to Map
class ShopProvider with ChangeNotifier {
  List<Product> _products = [];
  final Map<String, CartItem> _cart = {};
  List<Map<String, dynamic>> _orderHistory = []; 
  UserProfile? _profile;
  bool _isLoading = false;

  List<Product> get products => _products;
  List<CartItem> get cart => _cart.values.toList();
  int get cartCount => _cart.values.fold(0, (sum, i) => sum + i.quantity);
  List<Map<String, dynamic>> get orderHistory => _orderHistory;
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  String _selectedVendorFilter = 'All';
  String _selectedSortOrder = 'None'; // 'None', 'LowToHigh', 'HighToLow'

  String get selectedVendorFilter => _selectedVendorFilter;
  String get selectedSortOrder => _selectedSortOrder;

  ShopProvider() {
    _loadDataFromStorage(); // Automatically restore cache when the app boots up!
  }

  Future<void> _loadDataFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Restore User Profile Info
    final profileStr = prefs.getString('user_profile');
    if (profileStr != null) {
      _profile = UserProfile.fromJson(json.decode(profileStr));
    }

    // Restore Order History
    final orderStr = prefs.getString('order_history');
    if (orderStr != null) {
      _orderHistory = List<Map<String, dynamic>>.from(json.decode(orderStr));
    }

    // Restore Cart
    final cartStr = prefs.getString('cart');
    if (orderStr != null) {
      // _cart = Map<String, CartItem>.from(json.decode(cartStr));
    }

    notifyListeners();
  }

  Future<void> saveProfile(String name, String email) async {
    _profile = UserProfile(name: name, email: email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(_profile!.toJson()));
    notifyListeners();
  }

  // 3. Cache a Completed Checkout Session Order
  Future<void> cacheCompletedOrder(String total, List<Map<String, dynamic>> items) async {
    final newOrder = {
      'orderId': 'AZK-${DateTime.now().millisecondsSinceEpoch}',
      'timestamp': DateTime.now().toIso8601String(),
      'total': total,
      'items': items.map((i) => {'title': i['product'].title, 'quantity': i['quantity']}).toList(),
    };

    _orderHistory.insert(0, newOrder); // Put newest order at the top
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('order_history', json.encode(_orderHistory));
    notifyListeners();
  }


  List<String> get uniqueVendors {
    // The '??' safely protects against Null crashes if a productType is missing in JSON
    final vendors = _products
        .map((p) => p.productType.trim()) 
        .where((vendor) => vendor.isNotEmpty) // Drops clean blanks from your active filter options
        .toSet()
        .toList();
    return ['All', ...vendors];
  }

  List<Product> get filteredProducts {
    List<Product> output = List.from(_products);

    if (_selectedVendorFilter != 'All') {
      output = output.where((p) => p.productType.trim() == _selectedVendorFilter).toList();
    }

    if (_selectedSortOrder == 'LowToHigh') {
      output.sort((a, b) => (double.tryParse(a.price) ?? 0.0)
          .compareTo(double.tryParse(b.price) ?? 0.0));
    } else if (_selectedSortOrder == 'HighToLow') {
      output.sort((a, b) => (double.tryParse(b.price) ?? 0.0)
          .compareTo(double.tryParse(a.price) ?? 0.0));
    }

    return output;
  }

  void updateFilters({required String vendor, required String sort}) {
    _selectedVendorFilter = vendor;
    _selectedSortOrder = sort;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(AppConfig.productsEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((item) => Product.fromJson(item)).toList();
      }
    } catch (error) {
      print("Error fetching products: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  // TODO: Update cached cart
  void addToCart(Product product, int quantity) {
    final existing = _cart[product.variantId];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _cart[product.variantId] = CartItem(product: product, quantity: quantity);
    }

    notifyListeners(); // Updates the cart badge instantly
  }

  // TODO: Update cached cart
  void updateQuantity(String variantId, int newQty) {
    if (_cart.containsKey(variantId)) {
      if (newQty <= 0) {
        removeFromCart(variantId);
      }
      _cart[variantId]!.quantity = newQty;
    }

    notifyListeners();
  }

  // TODO: Update cached cart
  void removeFromCart(String variantId) {
    _cart.remove(variantId);
    notifyListeners();
  }

  // TODO: Clear cached cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
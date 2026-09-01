import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui' as ui;

import '../core/models/product.dart';
import '../models/user_profile.dart';
import '../models/order_history.dart';
import '../app_config.dart';
class ShopProvider with ChangeNotifier {
  String _appLanguage = 'en'; // Safe default parameter
  List<Product> _products = [];
  final Map<String, CartItem> _cart = {};
  // List<Map<String, dynamic>> _orderHistory = []; 
  final Map<String, OrderHistoryItem> _orders = {};
  UserProfile? _profile;
  bool _isLoading = false;
  Timer? _cartSaveTimer;


  String get appLanguage => _appLanguage;
  List<Product> get products => _products;
  List<CartItem> get cart => _cart.values.toList();
  int get cartCount => _cart.values.fold(0, (sum, i) => sum + i.quantity);
  List<OrderHistoryItem> get orderHistory => _orders.values.toList();
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
    try {
      final prefs = await SharedPreferences.getInstance();

      final String? cachedLang = prefs.getString('user_language_pref');
    
      if (cachedLang != null) {
        _appLanguage = cachedLang;
      } else {
        final String systemLocaleCode = ui.PlatformDispatcher.instance.locale.languageCode.toLowerCase();

        _appLanguage = (systemLocaleCode == 'hu') ? 'hu' : 'en';
      }

      final String? cachedCartString = prefs.getString('user_cart_cache');
      if (cachedCartString != null) {
        final Map<String, dynamic> decodedMap = json.decode(cachedCartString);
        decodedMap.forEach((key, value) {
          _cart[key] = CartItem.fromJson(value);
        });
      }

      final String? cachedOrdersString = prefs.getString('user_orders_cache');
      if (cachedOrdersString != null) {
        final Map<String, dynamic> decodedMap = json.decode(cachedOrdersString);
        decodedMap.forEach((key, value) {
          _orders[key] = OrderHistoryItem.fromJson(value);
        });
      }
      
      // Restore User Profile Info
      final profileStr = prefs.getString('user_profile');
      if (profileStr != null) {
        _profile = UserProfile.fromJson(json.decode(profileStr));
      }

      notifyListeners();
    } catch (e) {
      debugPrint("🚨 Caching Engine Read Fault: $e");
    }
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
      debugPrint("Error fetching products: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

// Persists the current cart map configuration onto memory disk storage
  Future<void> _saveCartToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> cartJsonMap = _cart.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('user_cart_cache', json.encode(cartJsonMap));
  }

  // Persists the current orders map configuration onto memory disk storage
  Future<void> _saveOrdersToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> ordersJsonMap = _orders.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString('user_orders_cache', json.encode(ordersJsonMap));
  }

  Future<void> _saveProfileToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(_profile!.toJson()));
  }

  Future<void> _saveLangToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_language_pref', _appLanguage);
  }

  // State mutations
  Future<void> saveProfile(String name, String email, String shippingAddress) async {
    _profile = UserProfile(name: name, email: email, shippingAddress: shippingAddress);
    await _saveProfileToDisk();
    notifyListeners();
  }

  Future<void> updateLanguage(String newLangCode) async {
    _appLanguage = newLangCode;
    await _saveLangToDisk();
    notifyListeners();
  }

  // Future<void> archiveCartToCompletedOrder(String totalAmount) async {
  Future<void> archiveCartToCompletedOrder() async {
    //TODO: Think about the shape of the data
    final String generatedOrderId = "AZK-${DateTime.now().millisecondsSinceEpoch}";

    double totalPrice = cart.fold(0, (total, item) {
      final price = double.tryParse(item.product.price) ?? 0.0;
      return total + price * item.quantity;
    });

    String totalAmount = "${totalPrice.toStringAsFixed(2)} HUF";

    // Create the finalized OrderHistoryItem summary node 
    final newOrderRecord = OrderHistoryItem(
      orderId: generatedOrderId,
      timestamp: DateTime.now().toIso8601String(),
      totalAmount: totalAmount,
      items: cart,
    );

    // Save into our persistent map using the generated ID as the key mapping anchor
    _orders[generatedOrderId] = newOrderRecord;

    _cart.clear(); // Flush out current cart bag
    
    // Atomically synchronize both updated database blocks onto device disk space
    await _saveCartToDisk();
    await _saveOrdersToDisk();
    notifyListeners();
  }

  void addToCart(Product product, int quantity) {
    final String trackingKey = product.variantId; // Might be useful: "${product.variantId}_$selectedSize"
    if (_cart.containsKey(trackingKey)) {
      _cart[trackingKey]!.quantity += quantity;
    } else {
      _cart[trackingKey] = CartItem(product: product, quantity: quantity);
    }

     notifyListeners(); //Update the screen UI instantly so the user sees no lag!

    //Cancel any pending file writes if the user clicks again quickly
    _cartSaveTimer?.cancel(); 
    
    // Schedule the file save to happen exactly 1 second AFTER the user stops interacting
    _cartSaveTimer = Timer(const Duration(seconds: 1), () {
      _saveCartToDisk(); 
    });
  }

  void updateQuantity(String variantId, int newQty) {
    if (_cart.containsKey(variantId)) {
      if (newQty <= 0) {
        removeFromCart(variantId);
      }
      _cart[variantId]!.quantity = newQty;
    }

    notifyListeners();

    //Cancel any pending file writes if the user clicks again quickly
    _cartSaveTimer?.cancel(); 
    
    // Schedule the file save to happen exactly 1 second AFTER the user stops interacting
    _cartSaveTimer = Timer(const Duration(seconds: 1), () {
      _saveCartToDisk(); 
    });
  }

  void removeFromCart(String variantId) {
    _cart.remove(variantId);

    _saveCartToDisk();
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();

    _saveCartToDisk();
    notifyListeners();
  }
}
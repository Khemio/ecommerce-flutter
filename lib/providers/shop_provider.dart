import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../app_config.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class ShopProvider with ChangeNotifier {
  List<Product> _products = [];
  // final List<Map<String, dynamic>> _cart = [];
  final Map<String, CartItem> _cart = {}; // keyed by variantId
  bool _isLoading = false;

  List<Product> get products => _products;
  // List<Map<String, dynamic>> get cart => _cart;
  List<CartItem> get cart => _cart.values.toList();
  int get cartCount => _cart.values.fold(0, (sum, i) => sum + i.quantity);
  bool get isLoading => _isLoading;

  String _selectedVendorFilter = 'All';
  String _selectedSortOrder = 'None'; // 'None', 'LowToHigh', 'HighToLow'

  String get selectedVendorFilter => _selectedVendorFilter;
  String get selectedSortOrder => _selectedSortOrder;

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

  void addToCart(Product product, int quantity) {
    final existing = _cart[product.variantId];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _cart[product.variantId] = CartItem(product: product, quantity: quantity);
    }

    notifyListeners(); // Updates the cart badge instantly
  }

  void removeFromCart(String variantId) {
    _cart.remove(variantId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
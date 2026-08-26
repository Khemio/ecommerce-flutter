import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import '../app_config.dart';

class ShopProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Map<String, dynamic>> _cart = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Map<String, dynamic>> get cart => _cart;
  bool get isLoading => _isLoading;

  String _selectedVendorFilter = 'All';
  String _selectedSortOrder = 'None'; // 'None', 'LowToHigh', 'HighToLow'

  String get selectedVendorFilter => _selectedVendorFilter;
  String get selectedSortOrder => _selectedSortOrder;

  // 1. Get a unique list of all brands/vendors present in your Shopify payload data stream
  List<String> get uniqueVendors {
    // final vendors = _products.map((p) => p.productType).toSet().toList();
    // return ['All', ...vendors];

    // The '??' safely protects against Null crashes if a productType is missing in JSON
    final vendors = _products
        .map((p) => p.productType.trim()) 
        .where((vendor) => vendor.isNotEmpty) // Drops clean blanks from your active filter options
        .toSet()
        .toList();
    return ['All', ...vendors];
  }

  // 2. Computes the output list on the fly based on filter settings
  List<Product> get filteredProducts {
    List<Product> output = List.from(_products);

    // Apply Brand Vendor Filter
    if (_selectedVendorFilter != 'All') {
      // output = output.where((p) => p.productType == _selectedVendorFilter).toList();
      output = output.where((p) => p.productType.trim() == _selectedVendorFilter).toList();
    }

    // Apply Price Sorting Logic
    // if (_selectedSortOrder == 'LowToHigh') {
    //   output.sort((a, b) => (double.tryParse(a.price) ?? 0.0).compareTo(double.tryParse(b.price) ?? 0.0));
    // } else if (_selectedSortOrder == 'HighToLow') {
    //   output.sort((a, b) => (double.tryParse(b.price) ?? 0.0).compareTo(double.tryParse(a.price) ?? 0.0));
    // }

    if (_selectedSortOrder == 'LowToHigh') {
      output.sort((a, b) => (double.tryParse(a.price) ?? 0.0)
          .compareTo(double.tryParse(b.price) ?? 0.0));
    } else if (_selectedSortOrder == 'HighToLow') {
      output.sort((a, b) => (double.tryParse(b.price) ?? 0.0)
          .compareTo(double.tryParse(a.price) ?? 0.0));
    }

    return output;
  }

  // 3. Setter update controls that force the UI grids to refresh automatically
  void updateFilters({required String vendor, required String sort}) {
    _selectedVendorFilter = vendor;
    _selectedSortOrder = sort;
    notifyListeners(); // Redraws screen layout panels instantly
  }

  // 1. Fetch mystery boxes from your Shopify proxy
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners(); // Tells the UI to show a loading spinner

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
    notifyListeners(); // Tells the UI to hide the spinner and show products
  }

  // 2. Add an item to the cart
  void addToCart(Product product, String selectedSize) {
    _cart.add({
      'product': product,
      'size': selectedSize,
      'quantity': 1,
    });
    notifyListeners(); // Updates the cart badge instantly
  }

  // 3. Clear cart after successful demo purchase
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
import 'package:azkomoly_app/core/models/remote_order.dart';
import 'package:azkomoly_app/features/cart/order_success_screen.dart';
import 'package:azkomoly_app/features/cart/sse_timeout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:ui' as ui;

import '../models/product.dart';

import 'package:azkomoly_app/banner_config.dart';
import 'package:azkomoly_app/app_config.dart';
import 'package:azkomoly_app/core/models/banner_items.dart';
import 'package:azkomoly_app/core/models/shipping_address.dart';
import 'package:azkomoly_app/core/models/user_profile.dart';

import 'package:azkomoly_app/features/profile/models/order_history.dart';
import 'package:azkomoly_app/features/home/models/social_review_data.dart';
class ShopProvider with ChangeNotifier {
  String _appLanguage = 'en';
  List<Product> _products = [];
  final Map<String, CartItem> _cart = {};
  final Map<String, OrderHistoryItem> _orders = {};
  UserProfile? _profile;
  bool _isLoading = false;
  Timer? _cartSaveTimer;
  Timer? _sseTimeoutTimer;
  StreamSubscription? _sseStreamSubscription;
  // String? _sessionId;

  String get appLanguage => _appLanguage;
  List<Product> get products => _products;
  List<CartItem> get cart => _cart.values.toList();
  int get cartCount => _cart.values.fold(0, (sum, i) => sum + i.quantity);
  List<OrderHistoryItem> get orderHistory => _orders.values.toList();
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  String _selectedTypeFilter = 'All';
  String _selectedVendorFilter = 'All';

  String _selectedSortOrder = 'None'; // 'None', 'LowToHigh', 'HighToLow'

  String get selectedTypeFilter => _selectedTypeFilter;
  String get selectedVendorFilter => _selectedVendorFilter;

  String get selectedSortOrder => _selectedSortOrder;

  AppLayoutConfig _layoutConfig = AppLayoutConfig(
    isPromoCarouselEnabled: true,
    isSocialCarouselEnabled: true,
    promoBanners: [],
    socialReviews: demoReviews,
  );

  AppLayoutConfig get layoutConfig => _layoutConfig;

  ShopProvider() {
    _loadDataFromStorage();
  }

  //TODO: Fix this: 'TypeError: 10490: type 'int' is not a subtype of type 'String''
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

  List<String> get uniqueProductTypes {
    final types = _products.map((p) => p.productType.trim()).where((t) => t.isNotEmpty).toSet().toList();
    return ['All', ...types];
  }

  List<String> get uniqueVendors {
    // Assumes you add an explicit 'vendor' String field to your Product model later
    final vendors = _products.map((p) => p.vendor.trim()).where((v) => v.isNotEmpty).toSet().toList();
    return ['All', ...vendors];
  }

  bool get isTypeFilteringEnabled => uniqueProductTypes.length > 1;
  bool get isVendorFilteringEnabled => uniqueVendors.length > 1;

  List<Product> get filteredProducts {
    List<Product> output = List.from(_products);
    if (_selectedTypeFilter != 'All') {
      output = output.where((p) => p.productType.trim() == _selectedTypeFilter).toList();
    }

    if (_selectedVendorFilter != 'All') {
      output = output.where((p) => p.vendor.trim() == _selectedVendorFilter).toList();
    }

    if (_selectedSortOrder == 'LowToHigh') {
      output.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSortOrder == 'HighToLow') {
      output.sort((a, b) => (b.price).compareTo(a.price));
    }

    return output;
  }

  void updateFilters({
    required String productType,
    required String vendor,
    required String sort
  }) {
    _selectedTypeFilter = productType;
    _selectedVendorFilter = vendor;
    _selectedSortOrder = sort;
    notifyListeners();
  }

  Future<void> fetchRemoteConfiguration() async {
    try {
      final response = await http.get(AppConfig.configEndpoint).timeout(const Duration(seconds: 3));
      
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        _layoutConfig = AppLayoutConfig.fromJson(decodedData);
        notifyListeners();
        debugPrint("🌐 Remote app config synchronized successfully!");
      } else {
        _layoutConfig = AppLayoutConfig.defaultConfig(
          promoBanners: products.sublist(0,5).map((product) {
            return PromoBanner(
              imageUrl: product.imageUrl,
              redirectUrl: 'azkomoly://product/${product.id}'
            );
          }).toList()
        );
      }
    } catch (e) {
      // Bypasses crashing completely! Falls back gracefully to your local parameters

      debugPrint("⚠️ Server config fetch failed. Using local hardware asset fallbacks. Error: $e");
    }
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(AppConfig.productsEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((item) => Product.fromJson(item)).toList();

        await fetchRemoteConfiguration();
      }
    } catch (error) {
      debugPrint("Error fetching products: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  int _currentRetryCount = 0;
  static const int _maxRetryAttempts = 5;
  bool _isExplicitlyStopped = false;


  void listenToSSE(BuildContext context, String sessionId) {
    _isExplicitlyStopped = false;
    stopListeningToSSE();

    final url = Uri.parse(
      AppConfig.orderEndpoint.toString(),
    ).replace(
      queryParameters: {
        'sessionId': sessionId,
      },
    );

    // _sseTimeoutTimer = Timer(const Duration(seconds: 2), () {
    _sseTimeoutTimer = Timer(const Duration(minutes: 15), () {
      debugPrint("⏳ SSE connection reached 15-minute timeout limit. Shutting down.");
      stopListeningToSSE();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => OrderProcessingTimeoutScreen(sessionId: sessionId,),
          ),
          (route) => route.isFirst, // Drops everything else except the root HomeScreen
        );
      }
    });

    _connectToStream(context, url.toString());

    
  }

  void _connectToStream(BuildContext context, String urlString) {
    if (_isExplicitlyStopped) return;

    _sseStreamSubscription = SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: urlString,
      header: {
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      },
    ).listen((event) async {
         // Reset retry counts instantly upon landing any structural message
        _currentRetryCount = 0;

        if (event.data == null || event.data!.isEmpty || event.data == 'null') {
          return;
        }

        switch (event.event) {  
          case 'order.created':
            // debugPrint('Event: ${event.event}');
            _isExplicitlyStopped = true;
            if (context.mounted) handleOrderCreated(context, event.data!);

          default: return;
        }
        
      },
      onError: (error) {
        debugPrint("SSE Network Stream Error: $error");
        if (context.mounted) _handleReconnection(context, urlString);
      },
      // onDone: () {
      //   debugPrint("📡 SSE Connection closed by remote server.");
      //   _handleReconnection(context, urlString);
      // },
    );
  }

  void _handleReconnection(BuildContext context, String urlString) {
    if (_isExplicitlyStopped || _currentRetryCount >= _maxRetryAttempts) {
      return;
    }

    _currentRetryCount++;
    
    // Calculate Backoff: Attempt 1 = 1s, Attempt 2 = 2s, Attempt 3 = 4s, Attempt 4 = 8s...
    final backoffDuration = Duration(seconds: 1 << _currentRetryCount);
    debugPrint("🔄 Reconnecting to SSE in ${backoffDuration.inSeconds} seconds... (Attempt $_currentRetryCount/$_maxRetryAttempts)");

    _sseStreamSubscription?.cancel();
    
    Timer(backoffDuration, () {
      _connectToStream(context, urlString);
    });
  }

  void handleOrderCreated(BuildContext context, String data) async {
    try {
      final Map<String, dynamic> remoteOrderJson = json.decode(data);

      final remoteOrder = RemoteOrder.fromJson(remoteOrderJson);

      if (!remoteOrder.isValid) {
        return;
      }
      
      await archiveCartToCompletedOrder(remoteOrder); 
      stopListeningToSSE();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSuccessScreen(
              orderNumber: remoteOrder.orderNumber.toString(),
              confirmationNumber: remoteOrder.confirmationNumber,
            ),
          ),
          (route) => route.isFirst, // Drops everything else except the root HomeScreen
        );
      }
    } catch (e) {
      debugPrint(
        'Failed processing order SSE event: $e',
      );
    }

  }

  void stopListeningToSSE() {
    debugPrint('Closing SSE Stream');

    _isExplicitlyStopped = true;
    _currentRetryCount = 0;
    _sseTimeoutTimer?.cancel();
    _sseTimeoutTimer = null;

    _sseStreamSubscription?.cancel();
    _sseStreamSubscription = null;
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
  Future<void> saveProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String zipCode,
    required String city,
    required String streetAddress,
  }) async {
    _profile = UserProfile(
      firstName: firstName,
      lastName: lastName,
      email: email,
      address: ShippingAddress(
        zipCode: zipCode,
        city: city,
        streetAddress: streetAddress,
      )
    );
    await _saveProfileToDisk();
    notifyListeners();
  }

  Future<void> updateLanguage(String newLangCode) async {
    _appLanguage = newLangCode;
    await _saveLangToDisk();
    notifyListeners();
  }

  Future<void> archiveCartToCompletedOrder(RemoteOrder order) async {
    // double totalPrice = cart.fold(0, (total, item) {
    //   final price = item.product.price;
    //   return total + price * item.quantity;
    // });

    // String totalAmount = totalPrice.toPrice(currency: 'HUF');

    // final String generatedOrderId = "AZK-${DateTime.now().millisecondsSinceEpoch}";

    // Create the finalized OrderHistoryItem summary node 
    final newOrderRecord = OrderHistoryItem.fromOrder(
      order: order,
      cart: cart,
    );

    // Save into our persistent map using the generated ID as the key mapping anchor
    // _orders[generatedOrderId] = newOrderRecord;
    _orders[newOrderRecord.orderId] = newOrderRecord;

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
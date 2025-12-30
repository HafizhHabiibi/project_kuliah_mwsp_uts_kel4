import 'package:project_kuliah_mwsp_uts_kel4/models/cart_item_model.dart';
import 'package:project_kuliah_mwsp_uts_kel4/models/product_model.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/api_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/product_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/config/app_config.dart';

class CartService {
  // Singleton pattern
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // Services
  final ApiService _apiService = ApiService();
  final ProductService _productService = ProductService();

  // User-specific cart storage: Map of userId to their cart items
  final Map<String, List<CartItemModel>> _userCarts = {};
  String? _currentUserId;

  // Set current logged-in user
  void setCurrentUser(String? userId) {
    _currentUserId = userId;
    // Initialize cart for new user if doesn't exist
    if (userId != null && !_userCarts.containsKey(userId)) {
      _userCarts[userId] = [];
    }
  }

  // Get current user's cart
  List<CartItemModel> _getCurrentUserCart() {
    if (_currentUserId == null) return [];
    return _userCarts[_currentUserId] ?? [];
  }

  // Get all cart items for current user
  List<CartItemModel> getCartItems() {
    return List.unmodifiable(_getCurrentUserCart());
  }

  // Load cart from backend
  Future<void> loadCartFromBackend() async {
    if (_currentUserId == null) {
      print('⚠️ No user logged in, cannot load cart from backend');
      return;
    }

    try {
      print('📥 Loading cart from backend for user $_currentUserId...');
      final response = await _apiService.get(
        AppConfig.keranjang,
        needsAuth: true,
      );

      if (response.statusCode == 200) {
        final data = _apiService.parseResponse(response);
        print('📥 Cart response data: $data');
        
        if (data['success'] == true || data['status'] == 'success') {
          // Handle different response formats
          List<dynamic> cartData = [];
          
          // Check if data has 'items' key (new backend format)
          if (data['data'] != null && data['data']['items'] is List) {
            cartData = data['data']['items'] as List<dynamic>;
          } else if (data['data'] is List) {
            // Data is already a list (old format)
            cartData = data['data'] as List<dynamic>;
          } else if (data['data'] is Map) {
            // Data is a single object, wrap it in a list
            cartData = [data['data']];
          } else if (data['data'] == null) {
            // No data, empty cart
            cartData = [];
          }
          
          print('📥 Processing ${cartData.length} cart items...');
          
          // Clear current cart
          _userCarts[_currentUserId!] = [];
          
          // Load each cart item
          for (var item in cartData) {
            try {
              // Backend already includes product details, create ProductModel from item
              final product = ProductModel(
                idProduk: item['produk_id'],
                nama: item['nama'] ?? 'Unknown Product',
                gambarUrl: item['gambar_url'],
                kategori: item['kategori'] ?? 'Unknown',
                harga: _parsePrice(item['harga']),
                deskripsi: item['deskripsi'],
              );
              
              final cartItem = CartItemModel(
                id: '${item['produk_id']}_${item['size'] ?? 'MD'}',
                backendCartId: item['id'],
                product: product,
                quantity: item['jumlah'] ?? 1,
                size: item['size'] ?? 'MD',
                status: item['status'] ?? 'all',
              );
              
              _userCarts[_currentUserId!]!.add(cartItem);
              print('✅ Added cart item: ${product.nama} (${item['size']}) x${item['jumlah']}');
            } catch (e) {
              print('❌ Error loading cart item: $e');
            }
          }
          
          print('✅ Loaded ${_userCarts[_currentUserId!]!.length} items from backend');
        }
      }
    } catch (e) {
      print('❌ Error loading cart from backend: $e');
    }
  }

  // Add item to current user's cart (with backend sync)
  Future<void> addToCart(ProductModel product, int quantity, String size) async {
    if (_currentUserId == null) {
      print('⚠️ No user logged in, cannot add to cart');
      return;
    }

    // Ensure user's cart exists
    if (!_userCarts.containsKey(_currentUserId)) {
      _userCarts[_currentUserId!] = [];
    }

    final userCart = _userCarts[_currentUserId]!;

    // Create unique ID based on product ID and size
    final String cartItemId = '${product.idProduk}_$size';

    // Check if item already exists in cart
    final existingIndex = userCart.indexWhere((item) => item.id == cartItemId);

    if (existingIndex != -1) {
      // Update quantity if item already exists
      final existingItem = userCart[existingIndex];
      final newQuantity = existingItem.quantity + quantity;
      
      userCart[existingIndex] = existingItem.copyWith(quantity: newQuantity);
      
      // Update in backend
      if (existingItem.backendCartId != null) {
        await _updateCartInBackend(existingItem.backendCartId!, newQuantity);
      }
    } else {
      // Add new item to backend first
      final backendCartId = await _addCartToBackend(product.idProduk, quantity, size);
      
      // Add new item to local cart
      userCart.add(
        CartItemModel(
          id: cartItemId,
          backendCartId: backendCartId,
          product: product,
          quantity: quantity,
          size: size,
        ),
      );
    }
  }

  // Add cart item to backend
  Future<int?> _addCartToBackend(int productId, int quantity, String size) async {
    try {
      print('📤 Adding cart item to backend: product=$productId, qty=$quantity, size=$size');
      final response = await _apiService.post(
        AppConfig.keranjang,
        body: {
          'produk_id': productId,
          'jumlah': quantity,
          'size': size,
          'status': 'all',
        },
        needsAuth: true,
      );

      print('📥 Response status code: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = _apiService.parseResponse(response);
        print('📥 Parsed data: $data');
        
        if (data['data'] != null && data['data']['id'] != null) {
          print('✅ Cart item added to backend with ID: ${data['data']['id']}');
          return data['data']['id'];
        } else {
          print('⚠️ Response data does not contain ID: $data');
        }
      } else {
        print('❌ Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error adding cart to backend: $e');
    }
    return null;
  }

  // Update cart item quantity in backend
  Future<void> _updateCartInBackend(int backendCartId, int newQuantity) async {
    try {
      print('📤 Updating cart item in backend: id=$backendCartId, qty=$newQuantity');
      await _apiService.put(
        AppConfig.updateKeranjang(backendCartId),
        body: {'jumlah': newQuantity},
        needsAuth: true,
      );
      print('✅ Cart item updated in backend');
    } catch (e) {
      print('❌ Error updating cart in backend: $e');
    }
  }

  // Remove item from current user's cart (with backend sync)
  Future<void> removeFromCart(String cartItemId) async {
    if (_currentUserId == null) return;
    
    final userCart = _userCarts[_currentUserId];
    if (userCart != null) {
      // Find the item to get backend cart ID
      final item = userCart.firstWhere(
        (item) => item.id == cartItemId,
        orElse: () => CartItemModel(
          id: '',
          product: ProductModel(idProduk: 0, nama: '', kategori: '', harga: 0),
          quantity: 0,
          size: '',
        ),
      );
      
      // Remove from backend if has backend ID
      if (item.backendCartId != null) {
        await _removeCartFromBackend(item.backendCartId!);
      }
      
      // Remove from local cart
      userCart.removeWhere((item) => item.id == cartItemId);
    }
  }

  // Remove cart item from backend
  Future<void> _removeCartFromBackend(int backendCartId) async {
    try {
      print('📤 Removing cart item from backend: id=$backendCartId');
      await _apiService.delete(
        AppConfig.deleteKeranjang(backendCartId),
        needsAuth: true,
      );
      print('✅ Cart item removed from backend');
    } catch (e) {
      print('❌ Error removing cart from backend: $e');
    }
  }

  // Update item quantity in current user's cart
  void updateQuantity(String cartItemId, int newQuantity) {
    if (_currentUserId == null) return;

    if (newQuantity <= 0) {
      removeFromCart(cartItemId);
      return;
    }

    final userCart = _userCarts[_currentUserId];
    if (userCart != null) {
      final index = userCart.indexWhere((item) => item.id == cartItemId);
      if (index != -1) {
        final item = userCart[index];
        userCart[index] = item.copyWith(quantity: newQuantity);
        
        // Update in backend
        if (item.backendCartId != null) {
          _updateCartInBackend(item.backendCartId!, newQuantity);
        }
      }
    }
  }

  // Update item status in current user's cart
  void updateStatus(String cartItemId, String newStatus) {
    if (_currentUserId == null) return;

    final userCart = _userCarts[_currentUserId];
    if (userCart != null) {
      final index = userCart.indexWhere((item) => item.id == cartItemId);
      if (index != -1) {
        userCart[index] = userCart[index].copyWith(status: newStatus);
      }
    }
  }

  // Get total price of all items in current user's cart
  double getTotalPrice() {
    return _getCurrentUserCart().fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Get total number of items in current user's cart
  int getTotalItems() {
    return _getCurrentUserCart().fold(0, (sum, item) => sum + item.quantity);
  }

  // Clear current user's cart only
  void clearCart() {
    if (_currentUserId != null) {
      _userCarts[_currentUserId]?.clear();
    }
  }

  // Check if current user's cart is empty
  bool get isEmpty => _getCurrentUserCart().isEmpty;
  bool get isNotEmpty => _getCurrentUserCart().isNotEmpty;

  // Get current user ID (for debugging)
  String? get currentUserId => _currentUserId;

  // Helper method to parse price from various types (String, int, double)
  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}

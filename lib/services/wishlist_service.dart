import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/product_model.dart';
import 'auth_service.dart';

class WishlistService {
  final AuthService _authService = AuthService();

  /// ================= GET WISHLIST =================
  Future<List<ProductModel>> fetchWishlist() async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse(AppConfig.wishlist),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('FETCH WISHLIST: Status ${response.statusCode}');
    print('Response: ${response.body}');

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return (data['data'] as List)
          .map((item) => ProductModel.fromJson(item['product']))
          .toList();
    }

    throw Exception(data['message'] ?? 'Failed to load wishlist');
  }

  /// ================= ADD TO WISHLIST =================
  Future<bool> addToWishlist(int productId) async {
    final token = await _authService.getToken();

    if (token == null) return false;

    final body = {'produk_id': productId.toString()}; // ✅ key harus 'produk_id'
    print('ADD WISHLIST: Body: $body');

    final response = await http.post(
      Uri.parse(AppConfig.wishlist),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: body,
    );

    print('ADD WISHLIST: Status ${response.statusCode}');
    print('Response: ${response.body}');

    return response.statusCode == 201;
  }

  /// ================= REMOVE WISHLIST =================
  Future<bool> removeFromWishlist(int productId) async {
    final token = await _authService.getToken();

    if (token == null) return false;

    final url = '${AppConfig.wishlist}/$productId';
    print('REMOVE WISHLIST: URL: $url');

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('REMOVE WISHLIST: Status ${response.statusCode}');
    print('Response: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 204;
  }
}

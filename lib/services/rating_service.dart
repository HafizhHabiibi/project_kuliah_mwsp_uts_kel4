import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/review_model.dart';
import 'auth_service.dart';

class RatingService {
  /// ================= GET ALL RATINGS BY PRODUCT =================
  Future<List<ReviewModel>> fetchRatings(int produkId) async {
    final token = await AuthService.getToken();

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final url = '${AppConfig.baseUrl}${AppConfig.ratings}/$produkId';
    print('FETCH RATINGS: URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('FETCH RATINGS: Status ${response.statusCode}');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['success'] == true) {
        final List<dynamic> list = decoded['data'];
        return list.map((item) => ReviewModel.fromJson(item)).toList();
      } else {
        throw Exception(decoded['message'] ?? 'Failed to fetch ratings');
      }
    }

    throw Exception('Failed to fetch ratings with status ${response.statusCode}');
  }

  /// ================= SUBMIT NEW RATING =================
  Future<bool> submitRating(int produkId, double stars, String comment) async {
    final token = await AuthService.getToken();
    if (token == null) return false;

    final url = '${AppConfig.baseUrl}${AppConfig.ratings}';

    // Kirim sebagai integer
    final body = {
      'produk_id': produkId,
      'stars': stars.round(), // Bulatkan ke integer
      'comment': comment,
    };

    print('SUBMIT RATING: URL: $url');
    print('SUBMIT RATING: Body: $body');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json', // Penting untuk POST JSON
      },
      body: json.encode(body), // Encode ke JSON
    );

    print('SUBMIT RATING: Status ${response.statusCode}');
    print('Response: ${response.body}');

    return response.statusCode == 201;
  }
}

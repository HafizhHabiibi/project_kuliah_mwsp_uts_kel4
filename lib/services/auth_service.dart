import '../config/app_config.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // ================= REGISTER =================
  // Register lalu AUTO LOGIN
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        AppConfig.register,
        body: {'username': username, 'email': email, 'password': password},
        needsAuth: false,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 201 && data['status'] == 'success') {
        // setelah register → langsung login
        return await login(email: email, password: password);
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Registration failed',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        AppConfig.login,
        body: {'email': email, 'password': password},
        needsAuth: false,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // simpan token
        final token = data['token'];
        await _apiService.saveToken(token);

        final user = UserModel.fromJson(data['user']);

        return {'success': true, 'user': user, 'token': token};
      }

      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================= GET CURRENT USER =================
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _apiService.get(
        AppConfig.getUser,
        needsAuth: true,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 200 && data['status'] == 'success') {
        // backend mengirim user login di key "data"
        final user = UserModel.fromJson(data['data']);

        return {'success': true, 'user': user};
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Failed to get user info',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================= UPDATE PROFILE =================
  Future<Map<String, dynamic>> updateProfile({
    required String username,
    String? alamat,
    String? gambarUrl,
  }) async {
    try {
      Map<String, dynamic> body = {'username': username};

      if (alamat != null && alamat.isNotEmpty) {
        body['alamat'] = alamat;
      }

      if (gambarUrl != null && gambarUrl.isNotEmpty) {
        body['gambar_url'] = gambarUrl;
      }

      final response = await _apiService.put(
        AppConfig.updateProfile,
        body: body,
        needsAuth: true,
      );

      final data = _apiService.parseResponse(response);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final updatedUser = UserModel.fromJson(data['user']);
        return {'success': true, 'user': updatedUser};
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Update profile failed',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    try {
      await _apiService.post(AppConfig.logout, body: {}, needsAuth: true);
    } finally {
      // apapun hasilnya → hapus token
      await _apiService.removeToken();
    }
  }

  // ================= CHECK AUTH =================
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null && token.isNotEmpty;
  }

  // ================= GET TOKEN =================
  Future<String?> getToken() async {
    return await _apiService.getToken();
  }
}

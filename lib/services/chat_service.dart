import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ChatService {
  static String get baseUrl => AppConfig.baseUrl;

  /// ================= GET CHAT LIST =================
  static Future<List<dynamic>> getChats(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('CHAT STATUS: ${response.statusCode}');
    print('CHAT BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // ✅ FORMAT LARAVEL
      if (decoded is Map && decoded['data'] is List) {
        return decoded['data'];
      }

      // fallback kalau backend kirim array langsung
      if (decoded is List) {
        return decoded;
      }

      throw Exception('Unexpected chat response format');
    }

    throw Exception('Failed to load chats');
  }

  /// ================= GET MESSAGES =================
  static Future<List<dynamic>> getMessages(int chatId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$chatId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('MESSAGES STATUS: ${response.statusCode}');
    print('MESSAGES BODY: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // asumsi backend kirim:
      // { status: success, data: { messages: [] } }
      if (decoded is Map &&
          decoded['data'] != null &&
          decoded['data']['messages'] is List) {
        return decoded['data']['messages'];
      }

      // fallback
      if (decoded['messages'] is List) {
        return decoded['messages'];
      }

      return [];
    }

    throw Exception('Failed to load messages');
  }

  /// ================= SEND MESSAGE =================
  static Future<void> sendMessage(
    int chatId,
    String message,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/messages'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {'chat_id': chatId.toString(), 'message': message},
    );

    print('SEND MESSAGE STATUS: ${response.statusCode}');
    print('SEND MESSAGE BODY: ${response.body}');
  }
}

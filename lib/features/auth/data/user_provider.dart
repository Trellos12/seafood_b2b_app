import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? email;

  AuthState({
    required this.isAuthenticated,
    this.token,
    this.email,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  static const _tokenKey = 'auth_token';
  final _secureStorage = const FlutterSecureStorage();

  AuthNotifier() : super(AuthState(isAuthenticated: false)) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _secureStorage.read(key: _tokenKey);
    if (token != null) {
      // Email не декодируем — будет null, если перезапустить
      // но для защиты заказов достаточно токена
      state = AuthState(isAuthenticated: true, token: token);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse(
        'https://galileo.fish-star.com.gr/wp-json/jwt-auth/v1/token',
      );

      final res = await http.post(url, body: {
        'username': email,
        'password': password,
      });

      debugPrint('🔐 Ответ от сервера: ${res.statusCode}');
      debugPrint('🔐 Тело ответа: ${res.body}');

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final token = body['data']['token'];
        final decodedEmail = body['data']['email'];

        debugPrint('✅ JWT Token: $token');
        debugPrint('📧 Email: $decodedEmail');

        await _secureStorage.write(key: _tokenKey, value: token);

        state = AuthState(
          isAuthenticated: true,
          token: token,
          email: decodedEmail,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('❌ Ошибка при логине: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    state = AuthState(isAuthenticated: false);
  }
}

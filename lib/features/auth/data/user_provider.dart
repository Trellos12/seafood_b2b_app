import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // 👈 добавь эту строку

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final String? token;

  AuthState({required this.isAuthenticated, this.token});
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
      state = AuthState(isAuthenticated: true, token: token);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      // ⚠️ Заменить на свой эндпоинт если другой
      final response = await Uri.parse(
              'https://galileo.fish-star.com.gr/wp-json/jwt-auth/v1/token')
          .resolveUri(Uri(queryParameters: {
        'username': email,
        'password': password,
      }));

      final res = await http.post(response);
      if (res.statusCode == 200) {
        final token = jsonDecode(res.body)['token'];
        await _secureStorage.write(key: _tokenKey, value: token);
        state = AuthState(isAuthenticated: true, token: token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    state = AuthState(isAuthenticated: false);
  }
}

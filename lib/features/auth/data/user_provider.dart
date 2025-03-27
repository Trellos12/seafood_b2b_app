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
      final email = _extractEmailFromToken(token);
      state = AuthState(isAuthenticated: true, token: token, email: email);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await Uri.parse(
        'https://galileo.fish-star.com.gr/wp-json/jwt-auth/v1/token',
      );

      final res = await http.post(response, body: {
        'username': email,
        'password': password,
      });

      if (res.statusCode == 200) {
        final token = jsonDecode(res.body)['token'];
        final decodedEmail = _extractEmailFromToken(token);

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
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    state = AuthState(isAuthenticated: false);
  }

  String? _extractEmailFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = jsonDecode(payload);

      return payloadMap['data']?['user_email'];
    } catch (_) {
      return null;
    }
  }
}

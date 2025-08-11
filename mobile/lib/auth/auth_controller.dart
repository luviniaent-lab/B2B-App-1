import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthState {
  final bool isLoggedIn;
  final String? name;
  final String? email;
  final String? phone;
  final String? aadhaar;
  final String? accessToken;
  const AuthState({required this.isLoggedIn, this.name, this.email, this.phone, this.aadhaar, this.accessToken});

  AuthState copyWith({bool? isLoggedIn, String? name, String? email, String? phone, String? aadhaar, String? accessToken}) =>
      AuthState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        aadhaar: aadhaar ?? this.aadhaar,
        accessToken: accessToken ?? this.accessToken,
      );

  factory AuthState.loggedOut() => const AuthState(isLoggedIn: false);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.loggedOut()) {
    // Try to load persisted token on startup
    Future.microtask(_loadToken);
  }

  static const String _base = 'http://localhost:3001/api/v1';
  static const _tokenKey = 'access_token';
  final _storage = const FlutterSecureStorage();

  Future<void> _loadToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isLoggedIn: true, accessToken: token);
    }
  }

  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) return;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<bool> sendOtp(String phone) async {
    try {
      final res = await http.post(Uri.parse('$_base/auth/send-otp'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'phone': phone}));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyOtpAndLogin(String phone, String otp) async {
    // Dev fallback: allow predefined credentials even if server not reachable
    if (phone == '9999112233' && otp == '123456') {
      state = state.copyWith(isLoggedIn: true, phone: phone, accessToken: 'dev');
      await _persistToken('dev');
      return true;
    }

    try {
      final res = await http.post(Uri.parse('$_base/auth/verify-otp'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'phone': phone, 'otp': otp}));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final token = data['accessToken'] as String?;
        await _persistToken(token);
        state = state.copyWith(isLoggedIn: true, phone: phone, accessToken: token);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loginWithGoogle(String email) async {
    try {
      final res = await http.post(Uri.parse('$_base/auth/login-google'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'email': email}));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final token = data['accessToken'] as String?;
        await _persistToken(token);
        state = state.copyWith(isLoggedIn: true, email: email, accessToken: token);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> register({required String name, required String phone, required String email, required String aadhaar, required String otp}) async {
    try {
      final res = await http.post(Uri.parse('$_base/auth/register'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'name': name, 'phone': phone, 'email': email, 'aadhaar': aadhaar, 'otp': otp}));
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final token = data['accessToken'] as String?;
        await _persistToken(token);
        state = AuthState(isLoggedIn: true, name: name, phone: phone, email: email, aadhaar: aadhaar, accessToken: token);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    state = AuthState.loggedOut();
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) => AuthController());


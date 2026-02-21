import 'package:get_storage/get_storage.dart';

class TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final GetStorage _box = GetStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _box.write(_accessTokenKey, accessToken);
    await _box.write(_refreshTokenKey, refreshToken);
  }

  Future<void> saveAccessToken(String token) async {
    await _box.write(_accessTokenKey, token);
  }

  Future<String?> getAccessToken() async {
    return _box.read<String>(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _box.read<String>(_refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _box.remove(_accessTokenKey);
    await _box.remove(_refreshTokenKey);
  }

  Future<bool> isTokenAvailable() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Synchronous check — safe to call from route middleware.
  bool get hasToken {
    final token = _box.read<String>(_accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Synchronous read — used by [AuthInterceptor] fallback.
  T? read<T>(String key) => _box.read<T>(key);
}

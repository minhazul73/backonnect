import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSessionService {
  SupabaseSessionService() {
    // Seed from the persisted session (loaded locally by supabase_flutter).
    _cachedAccessToken = _client.auth.currentSession?.accessToken;

    // Keep cache in sync for the lifetime of the app.
    _subscription = _client.auth.onAuthStateChange.listen((data) {
      _cachedAccessToken = data.session?.accessToken;
    });
  }

  SupabaseClient get _client => Supabase.instance.client;

  StreamSubscription<AuthState>? _subscription;
  String? _cachedAccessToken;

  bool get hasSession => _client.auth.currentSession != null;

  /// Synchronous access-token read (in-memory). Useful for fast checks.
  String? get cachedAccessToken => _cachedAccessToken;

  Future<String?> getAccessToken() async {
    // Prefer cached token to avoid repeated reads.
    final cached = _cachedAccessToken;
    if (cached != null && cached.isNotEmpty) return cached;

    final token = _client.auth.currentSession?.accessToken;
    _cachedAccessToken = token;
    return token;
  }

  /// Forces a refresh of the current session.
  ///
  /// Returns the new access token if refresh succeeded.
  Future<String?> refreshSession() async {
    final response = await _client.auth.refreshSession();
    final token = response.session?.accessToken;
    _cachedAccessToken = token;
    return token;
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    _cachedAccessToken = null;
  }

  /// Call only if you intentionally want to release resources.
  ///
  /// Not currently used because this service is registered as a permanent
  /// singleton.
  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}

class SupabaseEnv {
  SupabaseEnv._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Web client ID from Google Cloud (OAuth 2.0 Client ID).
  ///
  /// Required for native Google sign-in with Supabase on Android.
  static const String googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  static void assertConfigured() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing Supabase config. Provide --dart-define=SUPABASE_URL=... '
        'and --dart-define=SUPABASE_ANON_KEY=... at build/run time.',
      );
    }
  }
}

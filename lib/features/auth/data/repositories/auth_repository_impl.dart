import 'package:backonnect/core/auth/supabase_session_service.dart';
import 'package:backonnect/core/config/supabase_env.dart';
import 'package:backonnect/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:backonnect/features/auth/domain/entities/user_entity.dart';
import 'package:backonnect/features/auth/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final SupabaseSessionService sessionService;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.sessionService,
  });

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    if (SupabaseEnv.googleWebClientId.isEmpty) {
      throw const AuthException(
        'Missing GOOGLE_WEB_CLIENT_ID. Provide it via --dart-define.',
      );
    }

    final googleSignIn = GoogleSignIn(
      serverClientId: SupabaseEnv.googleWebClientId,
    );

    final account = await googleSignIn.signIn();
    if (account == null) {
      // User cancelled.
      return;
    }

    final auth = await account.authentication;
    final idToken = auth.idToken;
    final accessToken = auth.accessToken;

    if (idToken == null || idToken.isEmpty) {
      throw const AuthException('No Google ID token returned.');
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final model = await remoteDatasource.getCurrentUser();
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await sessionService.signOut();
  }
}

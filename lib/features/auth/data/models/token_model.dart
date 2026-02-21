import 'package:backonnect/features/auth/domain/entities/token_entity.dart';

class TokenModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
    );
  }

  TokenEntity toEntity() {
    return TokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
    );
  }
}

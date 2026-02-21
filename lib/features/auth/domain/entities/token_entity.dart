class TokenEntity {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });
}

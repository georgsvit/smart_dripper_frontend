class JWTTokenResponse {
  final String token;
  final DateTime expireDate;

  JWTTokenResponse._(this.token, this.expireDate);

  factory JWTTokenResponse.fromJson(Map<String, dynamic> json) {
    return new JWTTokenResponse._(
      json['token'],
      json['expireDate']
    );
  }
}
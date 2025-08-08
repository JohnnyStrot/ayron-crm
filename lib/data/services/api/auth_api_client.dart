import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../utils/result.dart';

class AuthApiClient {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final String _clientId = 'ayron-crm';
  final String _redirectUrl = 'de.ayronband.crm://callback';
  final String _issuer = 'https://johnnyst.de:8443/realms/applications';
  final List<String> _scopes = ['openid', 'offline_access'];

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _idTokenKey = 'id_token';

  Future<Result<void>> login() async {
    try {
      final AuthorizationTokenResponse result = await _appAuth
          .authorizeAndExchangeCode(
            AuthorizationTokenRequest(
              _clientId,
              _redirectUrl,
              promptValues: ['login'],
              issuer: _issuer,
              scopes: _scopes,
            ),
          );
      // Store tokens securely
      await _secureStorage.write(
        key: _accessTokenKey,
        value: result.accessToken,
      );
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: result.refreshToken,
      );
      await _secureStorage.write(key: _idTokenKey, value: result.idToken);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<Result<void>> logout() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      await _secureStorage.delete(key: _idTokenKey);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> refreshTokens() async {
    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) {
        return Result.error(Exception("No token stored"));
      }

      final TokenResponse result = await _appAuth.token(
        TokenRequest(
          _clientId,
          _redirectUrl,
          issuer: _issuer,
          refreshToken: refreshToken,
        ),
      );

      await _secureStorage.write(
        key: _accessTokenKey,
        value: result.accessToken,
      );
      if (result.refreshToken != null) {
        await _secureStorage.write(
          key: _refreshTokenKey,
          value: result.refreshToken,
        );
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}

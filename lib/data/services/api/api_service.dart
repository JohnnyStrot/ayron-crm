import 'dart:convert';

import 'package:ayron_crm/data/services/api/auth_api_client.dart';
import 'package:ayron_crm/utils/result.dart';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService({required AuthApiClient authApiClient})
    : _authApiClient = authApiClient;

  final AuthApiClient _authApiClient;
  final String _baseUrl = String.fromEnvironment(
    'backend_url',
    defaultValue: 'http://localhost:4003',
  );

  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? params,
  }) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }
    Uri uri = Uri.parse('$_baseUrl/$endpoint');
    if (params != null) {
      uri = Uri(
        scheme: uri.scheme,
        fragment: uri.fragment,
        host: uri.host,
        path: uri.path,
        port: uri.port,
        userInfo: uri.userInfo,
        queryParameters: params.map(
          (k, v) => v is Iterable<String>
              ? MapEntry(k, v)
              : MapEntry(k, v.toString()),
        ),
      );
    }

    var response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // If token expired (server returns 403)
    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.get(
            uri,
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    var response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.post(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    var response = await http.put(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.put(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }

  Future<http.Response> delete(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    var token = await _authApiClient.getAccessToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    var response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 403) {
      final refreshResult = await _authApiClient.refreshTokens();
      switch (refreshResult) {
        case Ok<void>():
          token = await _authApiClient.getAccessToken();
          // Retry the request with new token
          response = await http.delete(
            Uri.parse('$_baseUrl/$endpoint'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          );
        case Error<void>():
          // Refresh failed, user must log in again
          throw Exception('Session expired, please log in again.');
      }
    }

    return response;
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_list_app/core/constants/app_constants.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? query,
  }) async {
    final uri = Uri.parse(AppConstants.baseUrl).replace(
      path: path,
      queryParameters: query,
    );

    final response = await _client.get(
      uri,
      headers: const {'Content-Type': 'application/json'},
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body);
    if (decoded is List) {
      return decoded;
    }

    throw ApiException('Unexpected response format');
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse(AppConstants.baseUrl).replace(path: path);

    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode(body),
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw ApiException('Unexpected response format');
  }

  void dispose() {
    _client.close();
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Request failed (${response.statusCode})');
    }
  }
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

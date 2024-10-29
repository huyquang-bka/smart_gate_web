import 'dart:convert';
import 'package:http/http.dart' as http;

class NoAuthHttpClient {
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse(endpoint);
    return http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 5));
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse(endpoint);
    return http.post(
      url,
      body: jsonEncode(body),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 5));
  }
}

final noAuthHttpClient = NoAuthHttpClient();

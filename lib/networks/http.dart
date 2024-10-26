import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_gate_web/auth/auth_service.dart';
import 'package:smart_gate_web/configs/api_route.dart';

class CustomHttpClient {
  Auth? _auth;
  late Future<void> _initialization;

  CustomHttpClient() {
    _initialization = _loadAuth();
  }

  Future<void> _loadAuth() async {
    _auth = await AuthService.getAuth();
  }

  Future<http.Response> get(String endpoint) async {
    await _initialization;
    final response = await _getRequestWithToken(endpoint);
    if (response.statusCode == 401 || response.statusCode == 500) {
      final refreshSuccess = await _refreshToken();
      if (refreshSuccess) {
        return _getRequestWithToken(endpoint);
      } else {
        throw SessionExpiredException();
      }
    }
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    await _initialization;
    final response = await _postRequestWithToken(endpoint, body);
    if (response.statusCode == 401 || response.statusCode == 500) {
      final refreshSuccess = await _refreshToken();
      if (refreshSuccess) {
        return _postRequestWithToken(endpoint, body);
      } else {
        throw SessionExpiredException();
      }
    }
    return response;
  }

  Future<http.Response> _getRequestWithToken(String endpoint) {
    final url = Uri.parse(endpoint);
    return http.get(url, headers: {
      'Authorization': 'Bearer ${_auth?.accessToken ?? ''}',
    }).timeout(const Duration(seconds: 5));
  }

  Future<http.Response> _postRequestWithToken(
      String endpoint, Map<String, dynamic> body) {
    final url = Uri.parse(endpoint);
    return http.post(url, body: jsonEncode(body), headers: {
      'Authorization': 'Bearer ${_auth?.accessToken ?? ''}',
      'Content-Type': 'application/json',
    }).timeout(const Duration(seconds: 5));
  }

  Future<bool> _refreshToken() async {
    final url = Uri.parse(urlAuth);
    Map<String, String> payload = Map.from(bodyRefreshToken);
    payload["refresh_token"] = _auth?.refreshToken ?? '';
    try {
      final response =
          await http.post(url, body: jsonEncode(payload), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _auth = Auth(
          accessToken: body['access_token'],
          refreshToken: body['refresh_token'],
          username: _auth?.username ?? '',
          fullName: body['fullName'],
          laneId: body['laneId'] ?? -1,
          userId: body['userId'] ?? -1,
          compId: body['comId'] ?? -1,
        );
        await AuthService.saveAuth(_auth!);
        return true;
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return false;
  }

  Future<int> login(String username, String password) async {
    final url = Uri.parse(urlAuth);
    Map<String, String> payload = Map.from(bodyAuth);
    payload["username"] = username;
    payload["password"] = password;
    try {
      final response =
          await http.post(url, body: jsonEncode(payload), headers: {
        'Content-Type': 'application/json',
      }).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        _auth = Auth(
          accessToken: body['access_token'],
          refreshToken: body['refresh_token'],
          username: username,
          fullName: body['fullName'],
          laneId: body['laneId'] ?? -1,
          userId: body['userId'] ?? -1,
          compId: body['comId'] ?? -1,
        );
        await AuthService.saveAuth(_auth!);
      }
      return response.statusCode;
    } catch (e) {
      print("error: $e");
      return 500;
    }
  }
}

class SessionExpiredException implements Exception {
  @override
  String toString() => 'Phiên đăng nhập hết hạn';
}

CustomHttpClient customHttpClient = CustomHttpClient();

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gate_web/configs/constant.dart';

class Auth {
  String accessToken;
  String refreshToken;
  String username;
  String fullName;
  int laneId;
  int userId;
  int compId;

  Auth({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.fullName,
    required this.laneId,
    required this.userId,
    required this.compId,
  });

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'username': username,
        'fullName': fullName,
        'laneId': laneId,
        'userId': userId,
        'compId': compId,
      };

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        username: json['username'],
        fullName: json['fullName'],
        laneId: json['laneId'] as int,
        userId: json['userId'] as int,
        compId: json['compId'] as int,
      );
}

class AuthService {
  static Future<void> saveAuth(Auth auth) async {
    final prefs = await SharedPreferences.getInstance();
    final authJson = jsonEncode(auth.toJson());
    await prefs.setString(authKey, authJson);
  }

  static Future<Auth> getAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final authJson = prefs.getString(authKey);
    if (authJson == null) {
      return Auth(
          accessToken: "",
          refreshToken: "",
          username: "",
          fullName: "",
          laneId: -1,
          userId: -1,
          compId: -1);
    }
    return Auth.fromJson(jsonDecode(authJson));
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(authKey);
  }
}

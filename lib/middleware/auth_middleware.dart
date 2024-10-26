import 'package:flutter/material.dart';
import 'package:smart_gate_web/auth/auth_service.dart';
import 'package:smart_gate_web/pages/home.dart';
import 'package:smart_gate_web/pages/login/login.dart';

class AuthMiddleware {
  static Future<void> checkAuth(BuildContext context, Widget page) async {
    final auth = await AuthService.getAuth();
    if (page is HomePage && auth.accessToken.isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    } else if (page is LoginPage && auth.accessToken.isNotEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}

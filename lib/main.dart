import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:smart_gate_web/middleware/auth_middleware.dart';
import 'package:smart_gate_web/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Gate',
      theme: ThemeData(
        primaryColor: Colors.white,
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/home': (context) {
          AuthMiddleware.checkAuth(context, const HomePage());
          return const HomePage();
        },
      },
    );
  }
}

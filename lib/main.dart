import 'package:flutter/material.dart';
import 'features/auth/SplashScreen.dart';
import 'features/auth/login_page.dart';  
import 'features/auth/register_page.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}

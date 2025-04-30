import 'package:flutter/material.dart';
import 'features/auth/SplashScreen.dart';
import 'features/auth/login_page.dart';  
import 'features/auth/register_page.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/home/home_page.dart'; // Assuming you have a HomePage widget
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/home': (context) => HomePage(), // Assuming you have a HomePage widget
      },
    );
  }
}

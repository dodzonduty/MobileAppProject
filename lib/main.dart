import 'package:flutter/material.dart';
import 'features/auth/SplashScreen.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'features/home/views/home_page.dart'
    as home1; // Import the home.dart file with an alias
// Alias to resolve naming conflict

void main() async {
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
      home: LoginScreen(), // Use the correct HomePage class here,
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) =>
            home1.HomePage(), // Use alias to specify the correct HomePage
      },
    );
  }
}

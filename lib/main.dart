import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:project/features/courses/courses.dart';
import 'package:project/features/profile/Profile.dart';
import 'features/auth/SplashScreen.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:project/features/home/view/home_page.dart' as home1;
import 'features/events/view/root_screen.dart';
import 'BottomNavigetion.dart';
import 'features/notifications/Notifications.dart';
import 'features/database/Database.dart';
import 'features/transport/Transport.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationService();
  await notificationService.init();
  runApp(const MyApp());
  await DatabaseHelper().db;
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
        '/home': (context) => MainNavigation(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialSelectedIndex;
  MainNavigation({this.initialSelectedIndex = 0}) : super();

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;
  late final List<Widget> _pages;

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
    _pages = [
      home1.HomePage(),
      CoursesPage(onBackToHome: () => updateSelectedIndex(0)),
      RootScreen(
        onHome: () => updateSelectedIndex(0),
      ),
      TransportationPage(),
      EditProfilePage(onBackToHome: () => updateSelectedIndex(0)),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey('selectedIndex')) {
      final newIndex = args['selectedIndex'];
      if (newIndex is int && newIndex != _selectedIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handle physical back button
  Future<bool> _onWillPop() async {
    print('WillPopScope triggered, selectedIndex: $_selectedIndex, canPop: ${Navigator.of(context).canPop()}');
    if (_selectedIndex == 0) {
      // Show confirmation dialog
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Exit'),
            ),
          ],
        ),
      );
      print('Should exit: $shouldExit');
      if (shouldExit == true) {
        SystemNavigator.pop(); // Explicitly exit the app
        return true; // Allow default pop (fallback)
      }
      return false; // Stay in app if canceled
    } else {
      setState(() {
        _selectedIndex = 0; // Switch to HomePage
      });
      return false; // Prevent default pop
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _pages),
        bottomNavigationBar: BottomNavigationBarWidget(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
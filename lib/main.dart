import 'package:flutter/material.dart';
import 'package:project/features/profile/Profile.dart';
import 'features/auth/SplashScreen.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:project/features/home/view/home_page.dart' as home1;
import 'features/events/view/root_screen.dart';
import 'BottomNavigetion.dart';
// ignore: unused_import
import 'features/transport/transport.dart';
import 'features/notifications/Notifications.dart';
import 'features/database/Database.dart';
import 'features/transport/Transport.dart';

final GlobalKey<_MainNavigationState> mainNavigationKey =
    GlobalKey<_MainNavigationState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationService();
  await notificationService.init();
  runApp(const MyApp()
  );
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
        '/hom1': (context) => const HomePageWithNavigation(),
        '/home': (context) => MainNavigation(),
      },
    );
  }
}

class HomePageWithNavigation extends StatefulWidget {
  const HomePageWithNavigation({super.key});

  @override
  State<HomePageWithNavigation> createState() => _HomePageWithNavigationState();
}

class _HomePageWithNavigationState extends State<HomePageWithNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    home1.HomePage(),
    const PlaceholderWidget(label: 'Library'),
    // ← Here we pass the onHome callback into RootScreen:
    RootScreen(
      onHome: () => mainNavigationKey.currentState?.updateSelectedIndex(0),
    ),
    TransportationPage(),
    EditProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final int initialSelectedIndex;
  MainNavigation({this.initialSelectedIndex = 0})
      : super(key: mainNavigationKey);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    home1.HomePage(),
    const PlaceholderWidget(label: 'Library'),
    // ← And here too, for your primary navigation:
    RootScreen(
      onHome: () => mainNavigationKey.currentState?.updateSelectedIndex(0),
    ),
    TransportationPage(),
    EditProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
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
    setState(() => _selectedIndex = index);
  }

  /// Called by RootScreen via the global key.
  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;
  const PlaceholderWidget({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text(label, style: const TextStyle(fontSize: 24))),
    );
  }
}

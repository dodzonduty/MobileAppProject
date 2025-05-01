import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/home_model.dart';
import 'home_page.dart'; // Importing the original home_page.dart to access the widgets

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final HomeController _controller = HomeController(HomeModel());

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  left: 24,
                  top: 76,
                  child: Text(
                    _controller.getUserName(),
                    style: const TextStyle(
                      color: Color(0xFF0A2533),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
                const Positioned(left: 30, top: 56, child: WelcomeBackRow()),
                Positioned(
                  left: 321,
                  top: 70,
                  child: NotificationIcon(
                    notifications: _controller.getNotifications(),
                  ),
                ),
                // Other content...
              ],
            ),
          ),
          Positioned(
            left: 24,
            top: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [SearchBox(), SizedBox(height: 8)],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final List<String> notifications;
  const NotificationIcon({super.key, required this.notifications});

  void _showNotificationBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotificationBox(notifications: notifications);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications_active_outlined, size: 24),
      onPressed: () => _showNotificationBox(context),
    );
  }
}

class NotificationBox extends StatelessWidget {
  final List<String> notifications;
  const NotificationBox({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...notifications.map(
              (notification) => ListTile(
                leading: const Icon(Icons.notification_important),
                title: Text(notification),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'about_screen.dart';
import '../../Services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = 'Guest';
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    if (user != null) {
      String? email = user.email;
      if (email != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (doc.exists && doc.data()?['firstName'] != null) {
            setState(() {
              username = (doc.data()!['firstName'] as String).capitalize();
            });
            return;
          }
        } catch (e) {
          print('Error fetching Firestore data: $e');
        }

        final provider = user.providerData
            .firstWhere((data) => data.providerId != 'firebase',
                orElse: () => user.providerData.first)
            .providerId;
        if (provider == 'microsoft.com') {
          final regex = RegExp(r'([a-zA-Z]+)\d+@feng\.bu\.edu\.eg');
          final match = regex.firstMatch(email);
          setState(() {
            username = match?.group(1)?.capitalize() ?? email.split('@').first;
          });
        } else {
          setState(() {
            username = email.split('@').first;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  left: 24,
                  top: 76,
                  child: Text(
                    username,
                    style: TextStyle(
                      color: Color(0xFF0A2533),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ),
                Positioned(
                    left: 30,
                    top: 56,
                    child: WelcomeBackRow(username: username)),
                Positioned(
                  left: 321,
                  top: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [NotificationIcon()],
                  ),
                ),
                // Images and other content
                Positioned(
                  left: 38,
                  top: 198,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/Feng.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 95,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 45.75),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const WhiteTextLabel(text: 'About'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  left: 27,
                  top: 329,
                  child: BlackTextLabel(text: 'Latest News'),
                ),
                Positioned(
                  left: 199,
                  top: 197,
                  child: InkWell(
                    onTap: () {
                      print('Image lolo');
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            'assets/images/Tables.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Container(
                          height: 96,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const WhiteTextLabel(text: 'Schedule'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(left: 127, top: 380, child: NewsDescription()),
                const Positioned(left: 127, top: 490, child: NewsDescription()),
                const Positioned(left: 127, top: 602, child: NewsDescription()),
                const Positioned(left: 127, top: 437, child: DateLabel()),
                const Positioned(left: 127, top: 547, child: DateLabel()),
                const Positioned(left: 127, top: 659, child: DateLabel()),
                Positioned(left: 30, top: 378, child: NewsImageBox()),
                const Positioned(left: 30, top: 488, child: NewsImageBox()),
                const Positioned(left: 30, top: 600, child: NewsImageBox()),
                //const Positioned(left: 0, top: 0, child: StatusBar()),
              ],
            ),
          ),

          // SearchBox with dropdown list (placed on top of everything)
          Positioned(
            left: 24,
            top: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const SearchBox(), const SizedBox(height: 8)],
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeBackRow extends StatelessWidget {
  final String username;
  const WelcomeBackRow({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/images/Vector.jpg'),
        const SizedBox(width: 8),
        Text(
          'Welcome Back',
          style: TextStyle(
            color: Color(0xFF0A2533),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  void _showNotificationBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const NotificationBox();
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
  const NotificationBox({super.key});

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
            const ListTile(
              leading: Icon(Icons.notification_important),
              title: Text('Notification 1'),
            ),
            const ListTile(
              leading: Icon(Icons.notification_important),
              title: Text('Notification 2'),
            ),
            const ListTile(
              leading: Icon(Icons.notification_important),
              title: Text('Notification 3'),
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

class GreyBox extends StatelessWidget {
  final double width;
  final double height;
  const GreyBox({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: const Color(0xFFD9D9D9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

class BlueBox extends StatelessWidget {
  final double width;
  final double height;
  const BlueBox({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: const Color(0xFF445B70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

class NetworkImageBox extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  const NetworkImageBox({
    super.key,
    required this.width,
    required this.height,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final List<String> _values = [
    'IEEE',
    'MSP',
    'ICPC',
    'Shoubra Engineering Students Union',
    'GDG',
    'SRT',
    'Table ',
    'Profile',
  ];

  List<String> _filteredValues = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _filteredValues = _values; // Initialize with all values
  }

  void _filterValues(String query) {
    setState(() {
      _searchText = query;
      _filteredValues = _values
          .where(
            (value) => value.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 327,
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2, color: Color(0xFFE6EBF2)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF97A1B0), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: _filterValues,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Color(0xFF97A1B0),
                      fontSize: 16,
                      fontFamily: 'Sofia Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_searchText.isNotEmpty)
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 327,
              height: 200, // Adjust height as needed
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.builder(
                itemCount: _filteredValues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredValues[index]),
                    onTap: () {
                      // Handle item selection
                      print('Selected: ${_filteredValues[index]}');
                      setState(() {
                        _searchText = _filteredValues[index];
                        _filteredValues = _values; // Reset the list
                      });
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class WhiteTextLabel extends StatelessWidget {
  final String text;
  const WhiteTextLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        height: 1.35,
      ),
    );
  }
}

class BlackTextLabel extends StatelessWidget {
  final String text;
  const BlackTextLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        height: 1.35,
      ),
    );
  }
}

class NewsDescription extends StatelessWidget {
  const NewsDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 224,
      child: Text(
        'Dr. Tamer Samir inspects Aptitude \nTests at Faculties of Applied Arts \nand Physical Education\n',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 1.35,
          letterSpacing: -0.48,
        ),
      ),
    );
  }
}

class DateLabel extends StatelessWidget {
  const DateLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Feb 15, 2025',
      style: TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 10,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        height: 1.35,
        letterSpacing: -0.40,
      ),
    );
  }
}

class NewsImageBox extends StatelessWidget {
  const NewsImageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 80,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/news1.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  }
}

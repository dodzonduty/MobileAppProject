import 'package:flutter/material.dart';

typedef OnItemTapped = void Function(int index);

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final OnItemTapped onItemTapped;

  const BottomNavigationBarWidget({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/house 1.png')),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/book-open-text 1.png')),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/calendar-days 1.png')),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('images/bus 1.png')),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_identity_outlined),
          label: '',
        ),
      ],
    );
  }
}

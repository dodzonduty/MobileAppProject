import 'package:flutter/material.dart';

typedef OnItemTapped = void Function(int index);

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final OnItemTapped onItemTapped;

  const BottomNavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

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
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/house.png')),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/book-open-text.png')),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/calendar-days.png')),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/bus.png')),
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

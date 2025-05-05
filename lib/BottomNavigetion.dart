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
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bus_sharp),
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

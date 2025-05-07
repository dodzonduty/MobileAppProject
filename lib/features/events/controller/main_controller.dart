import 'package:flutter/material.dart';
import '../model/page_view_model.dart';

class MainController extends ChangeNotifier {
  int _selectedIndex = 2;

  int get selectedIndex => _selectedIndex;

  final List<PageViewModel> pages = [
    PageViewModel(
      pageNumber: 1,
      title: 'Page 1 Title',
      description:
          'The Shoubra Engineering Student Union is a dynamic organization dedicated to representing and supporting students at Shoubra Faculty of Engineering. It fosters academic excellence, professional development, and extracurricular engagement through various initiatives, including workshops, competitions, and networking events. The union serves as a bridge between students and faculty, ensuring their voices are heard and their concerns addressed. It also organizes social and cultural activities to enhance student life and create a strong sense of community. Through its efforts, the union empowers future engineers with the skills, knowledge, and opportunities needed for success.',
      imageAsset: 'images/1.png',
    ),
    PageViewModel(
      pageNumber: 2,
      title: 'Page 2 Title',
      description: 'Description for page 2.',
      imageAsset: 'images/2.png',
    ),
    PageViewModel(
      pageNumber: 3,
      title: 'Page 3 Title',
      description: 'Description for page 3.',
      imageAsset: 'images/3.png',
    ),
    PageViewModel(
      pageNumber: 4,
      title: 'Page 4 Title',
      description: 'Description for page 4.',
      imageAsset: 'images/4.png',
    ),
    PageViewModel(
      pageNumber: 5,
      title: 'Page 5 Title',
      description: 'Description for page 5.',
      imageAsset: 'images/5.png',
    ),
    PageViewModel(
      pageNumber: 6,
      title: 'Page 6 Title',
      description: 'Description for page 6.',
      imageAsset: 'images/6.png',
    ),
  ];

  void onItemTapped(int idx) {
    _selectedIndex = idx;
    notifyListeners();
  }
}

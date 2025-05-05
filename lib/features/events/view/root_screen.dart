// lib/features/events/view/root_screen.dart

import 'package:flutter/material.dart';
import 'main_view.dart';
import 'dynamic_page.dart';

class RootScreen extends StatefulWidget {
  /// NEW:
  /// A hook that tells your MainNavigation “go to index 0 (Home)”.
  final VoidCallback onHome;

  RootScreen({
    super.key,
    required this.onHome,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final int _currentIndex = 2; // still fixed on "Events" tab
  final _navKeys = List.generate(5, (index) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(5, (i) {
          return Offstage(
            offstage: _currentIndex != i,
            child: Navigator(
              key: _navKeys[i],
              onGenerateRoute: (settings) {
                late Widget page;
                switch (i) {
                  case 0:
                    page = _placeholder('Home');
                    break;
                  case 1:
                    page = _placeholder('Library');
                    break;
                  case 2:
                    page = MainView(
                      onItemTapped: (vm) {
                        _navKeys[i].currentState!.push(
                              MaterialPageRoute(
                                builder: (_) => DynamicPage(
                                  imageAsset: vm.imageAsset,
                                  title: vm.title,
                                  description: vm.description,
                                ),
                              ),
                            );
                      },
                      onBack: () {
                        // 1) If we're deep in the Events tab, pop that inner route:
                        if (_navKeys[i].currentState!.canPop()) {
                          _navKeys[i].currentState!.pop();
                        }
                        // 2) Then tell MainNavigation to switch to Home (index 0):
                        widget.onHome();
                      },
                    );
                    break;
                  case 3:
                    page = _placeholder('Transit');
                    break;
                  default:
                    page = _placeholder('Profile');
                }
                return MaterialPageRoute(builder: (_) => page);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _placeholder(String label) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text(label, style: const TextStyle(fontSize: 24))),
    );
  }
}

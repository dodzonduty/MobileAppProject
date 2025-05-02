import 'package:flutter/material.dart';
import 'main_view.dart';
import 'dynamic_page.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 2; // start on "Events" tab
  final _navKeys = List.generate(5, (_) => GlobalKey<NavigatorState>());

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

import 'package:flutter/material.dart';

import 'auth/widgets/registerlogin_text.dart';

class SilverAppBarWidget extends StatelessWidget {
  final String appBarText;
  const SilverAppBarWidget({super.key, required this.appBarText});

  @override
  Widget build(BuildContext context) {
    return //Disappears on scroll down and appears on scroll up
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              expandedHeight: 80,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 16, left: 3, right: 20),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.chevron_left, size: 30),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          appBarText,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            fontFamily: "Inter"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }
}
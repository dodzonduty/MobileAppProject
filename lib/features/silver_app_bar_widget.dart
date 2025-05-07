import 'package:flutter/material.dart';

import 'auth/widgets/registerlogin_text.dart';

class SilverAppBarWidget extends StatelessWidget {
  final String appBarText;
  final VoidCallback? onBackPressed;

  const SilverAppBarWidget({
    super.key,
    required this.appBarText,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.white,
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
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
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
                    fontFamily: "Inter",
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
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'event_page.dart';
import 'join_us_page.dart';

class DynamicPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  const DynamicPage({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = MediaQuery.of(context).size.width * 0.04;
    final vPad = MediaQuery.of(context).size.height * 0.03;

    final actions = [
      _ActionItem(
        label: 'Events',
        iconPath: 'assets/images/events.png',
        background: Colors.pink.shade50,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => EventPage(imageAsset: imageAsset)),
          );
        },
      ),
      _ActionItem(
        label: 'Join Us',
        iconPath: 'assets/images/join_us.png',
        background: Colors.teal.shade50,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const JoinUsPage()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 28),
          color: Colors.black87,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image card
            GestureDetector(
              onTap: actions[0].onPressed,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                clipBehavior: Clip.hardEdge,
                color:
                    imageAsset.contains('4.png') ? Colors.black : Colors.white,
                child: Image.asset(
                  imageAsset,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: vPad),
            // description
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: vPad),
            // buttons
            LayoutBuilder(
              builder: (context, constraints) {
                final btnW = (constraints.maxWidth - hPad) / 2;
                return Wrap(
                  spacing: hPad,
                  runSpacing: vPad,
                  children: actions.map((a) {
                    return SizedBox(
                      width: btnW,
                      child: ElevatedButton.icon(
                        onPressed: a.onPressed,
                        icon: Image.asset(a.iconPath, width: 24, height: 24),
                        label: Text(a.label,
                            style: const TextStyle(fontFamily: 'Inter')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: a.background,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  final String label;
  final String iconPath;
  final Color background;
  final VoidCallback onPressed;
  const _ActionItem({
    required this.label,
    required this.iconPath,
    required this.background,
    required this.onPressed,
  });
}

import 'package:flutter/material.dart';
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
    // Define your three action items
    final actions = [
      _ActionItem(
        ImageIcon(AssetImage('assets/images/events.png')),
        'Events',
        Colors.pink.shade50,
      ),
      _ActionItem(
        ImageIcon(AssetImage('assets/images/join_us.png')),
        'Join Us',
        Colors.teal.shade50,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black87, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventPage(imageAsset: imageAsset),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    clipBehavior: Clip.hardEdge,
                    color: imageAsset.contains('4.png')
                        ? Colors.black
                        : Colors.white,
                    child: Image.asset(
                      imageAsset,
                      width: 350,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 2) Description Text
                Text(
                  description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),

                const SizedBox(height: 24),

                // 3) Buttons in a 2-column Wrap
                LayoutBuilder(
                  builder: (context, constraints) {
                    final buttonWidth = (constraints.maxWidth - 16) / 2;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: actions.map((action) {
                        return SizedBox(
                          width: buttonWidth,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (action.label == 'Events') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventPage(imageAsset: imageAsset),
                                  ),
                                );
                              } else if (action.label == 'Join Us') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JoinUsPage(),
                                  ),
                                );
                              }
                            },
                            icon: action.icon,
                            label: Text(
                              action.label,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: action.background,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

                // Optional bottom padding so content isn't hidden under nav bar
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Simple helper class for actions
class _ActionItem {
  final Widget icon;
  final String label;
  final Color background;
  const _ActionItem(this.icon, this.label, this.background);
}

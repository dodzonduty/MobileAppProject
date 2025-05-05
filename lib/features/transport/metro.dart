import 'package:flutter/material.dart';
import 'route_controller.dart';

void showMetroRoutesPopup(BuildContext context) {
  final routeController = RouteController();
  final metroRoutes = routeController.getMetroRoutes();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(16.0),
        content: SizedBox(
          width: screenWidth * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🚇 Metro Routes to El-Khalafawi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...metroRoutes.map(
                  (station) => RouteCard(
                    icon: Icons.directions_subway,
                    title: station.title,
                    subtitle: '',
                    startingPoint: '',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            backgroundColor: Colors.white,
                            contentPadding: const EdgeInsets.all(20.0),
                            content: SizedBox(
                              width: screenWidth * 0.9,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF445B70),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.directions_subway,
                                            color: Color(0xFF445B70),
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Route to El-Khalafawi from ${station.title}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    station.description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text(
                                  'Close',
                                  style: TextStyle(
                                    color: Color(0xFF445B70),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF445B70),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class RouteCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String startingPoint;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.startingPoint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF445B70),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
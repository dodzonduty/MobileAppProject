import 'package:flutter/material.dart';
import 'route_controller.dart';
import 'route_model.dart';

void showBusRoutesPopup(BuildContext context) {
  final routeController = RouteController();
  final busRoutes = routeController.getBusRoutes();

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
                  '🚌 Public Transport Bus Routes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...busRoutes.where((route) => route.type == 'bus').map(
                      (route) => RouteCard(
                        icon: Icons.directions_bus,
                        title: route.title,
                        subtitle: route.subtitle,
                        startingPoint: route.startingPoint,
                      ),
                    ),
                const SizedBox(height: 24),
                const Text(
                  '🚐 Minibus Routes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...busRoutes.where((route) => route.type == 'minibus').map(
                      (route) => RouteCard(
                        icon: Icons.airport_shuttle,
                        title: route.title,
                        subtitle: route.subtitle,
                        startingPoint: route.startingPoint,
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
              style: TextStyle(color: Color(0xFF445B70), fontSize: 16),
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
  final VoidCallback? onTap;

  const RouteCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.startingPoint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF445B70),
            child: Icon(icon, color: Colors.white),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: (subtitle.isEmpty && startingPoint.isEmpty)
              ? null
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (startingPoint.isNotEmpty)
                      Text(
                        'From: $startingPoint',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ),
    );
  }
}
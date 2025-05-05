import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapButton extends StatelessWidget {
  final Position? currentPosition;

  const MapButton({super.key, this.currentPosition});

  void _openGoogleMaps(BuildContext context) async {
    const String destination = 'كلية الهندسة بشبرا';
    if (currentPosition == null) {
      final String query = 'https://www.google.com/maps/search/?api=1&query=$destination';
      final Uri uri = Uri.parse(query);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the map.')),
        );
      }
      return;
    }

    final String query =
        'https://www.google.com/maps/dir/?api=1&origin=${currentPosition!.latitude},${currentPosition!.longitude}&destination=$destination';
    final Uri uri = Uri.parse(query);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the map.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327,
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF445B70),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: () => _openGoogleMaps(context),
          borderRadius: BorderRadius.circular(32),
          splashColor: Colors.white,
          highlightColor: Colors.white,
          child: ElevatedButton.icon(
            onPressed: () => _openGoogleMaps(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(Icons.location_on, size: 20, color: Colors.white),
            label: const Text(
              'View in Maps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
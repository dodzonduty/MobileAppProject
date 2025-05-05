import 'package:flutter/material.dart';
import 'location_controller.dart';
import 'location_model.dart';
import 'bus.dart';
import 'metro.dart';
import 'maps.dart';

class TransportationPage extends StatefulWidget {
  const TransportationPage({super.key});

  @override
  _TransportationPageState createState() => _TransportationPageState();
}

class _TransportationPageState extends State<TransportationPage> {
  final locationModel = LocationModel();
  late LocationController locationController;

  @override
  void initState() {
    super.initState();
    locationController = LocationController(locationModel);
    locationController.getCurrentLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
        slivers: [
          // SliverAppBar that disappears on scroll
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
                        icon: Icon(
                          Icons.chevron_left,
                          size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _TransportationOptionCard(
                      label: 'Bus',
                      imagePath: 'assets/images/bus.jpg',
                      onTap: () => showBusRoutesPopup(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TransportationOptionCard(
                      label: 'Metro',
                      imagePath: 'assets/images/metro.jpg',
                      onTap: () => showMetroRoutesPopup(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/map.jpg',
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              MapButton(currentPosition: locationModel.currentPosition),
            ],
          ),
        ),
      ),
          ],
        ),
      ),
    );
  }
}

class _TransportationOptionCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onTap;

  const _TransportationOptionCard({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.asset(
              imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black45,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
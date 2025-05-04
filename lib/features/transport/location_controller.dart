import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'location_model.dart';

class LocationController {
  final LocationModel model;

  LocationController(this.model);

  Future<void> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      model.setError('Location services are disabled.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(model.errorMessage!)),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        model.setError('Location permissions are denied.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(model.errorMessage!)),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      model.setError('Location permissions are permanently denied, please enable them in settings.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(model.errorMessage!)),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      model.updatePosition(position);
    } catch (e) {
      model.setError('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(model.errorMessage!)),
      );
    }
  }
}
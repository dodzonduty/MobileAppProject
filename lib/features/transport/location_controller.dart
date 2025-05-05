import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'location_model.dart';
import 'dart:math' as math;

class LocationController {
  final LocationModel model;
  DateTime? lastGpsTime;
  List<double> velocity = [0.0, 0.0]; // [x, y] velocity in m/s
  DateTime? lastAccelTime;

  LocationController(this.model) {
    // Listen to accelerometer events
    accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        final now = DateTime.now();
        model.updateAccelerometerData([event.x, event.y, event.z]);

        // Only process if GPS is unavailable or stale
        if (model.currentPosition == null ||
            (lastGpsTime != null &&
                now.difference(lastGpsTime!).inSeconds > 5)) {
          _updateLocationFromAccelerometer(event, now);
        }
      },
      onError: (error) {
        model.setError('Error accessing accelerometer: $error');
      },
    );
  }

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
      lastGpsTime = DateTime.now();
      velocity = [0.0, 0.0]; // Reset velocity on new GPS fix
    } catch (e) {
      model.setError('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(model.errorMessage!)),
      );
    }
  }

  void _updateLocationFromAccelerometer(AccelerometerEvent event, DateTime now) {
    if (lastAccelTime == null || model.accelLatitude == null || model.accelLongitude == null) {
      lastAccelTime = now;
      return;
    }

    // Calculate time delta
    final deltaT = now.difference(lastAccelTime!).inMilliseconds / 1000.0; // in seconds
    lastAccelTime = now;

    // Update velocity (v = v0 + a * t)
    velocity[0] += event.x * deltaT; // x-axis velocity
    velocity[1] += event.y * deltaT; // y-axis velocity

    // Calculate displacement (s = v * t)
    final displacementX = velocity[0] * deltaT; // in meters
    final displacementY = velocity[1] * deltaT; // in meters

    // Convert displacement to latitude/longitude (approximate)
    const earthRadius = 6371000; // meters
    final deltaLat = (displacementY / earthRadius) * (180 / math.pi); // degrees
    final deltaLon = (displacementX / (earthRadius * math.cos(model.accelLatitude! * math.pi / 180))) * (180 / math.pi); // degrees

    // Update location
    final newLat = model.accelLatitude! + deltaLat;
    final newLon = model.accelLongitude! + deltaLon;
    model.updateAccelLocation(newLat, newLon);
  }
}
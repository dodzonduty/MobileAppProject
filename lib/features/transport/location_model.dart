import 'package:geolocator/geolocator.dart';

class LocationModel {
  Position? currentPosition;
  String? errorMessage;
  List<double>? accelerometerData; // Stores [x, y, z] acceleration values
  double? accelLatitude; // Accelerometer-derived latitude
  double? accelLongitude; // Accelerometer-derived longitude
  String locationSource = 'GPS'; // Tracks whether location is from GPS or accelerometer

  void updatePosition(Position position) {
    currentPosition = position;
    accelLatitude = position.latitude;
    accelLongitude = position.longitude;
    errorMessage = null;
    locationSource = 'GPS';
  }

  void setError(String message) {
    errorMessage = message;
    currentPosition = null;
    accelerometerData = null;
    accelLatitude = null;
    accelLongitude = null;
    locationSource = 'None';
  }

  void updateAccelerometerData(List<double> data) {
    accelerometerData = data;
    errorMessage = null;
  }

  void updateAccelLocation(double latitude, double longitude) {
    accelLatitude = latitude;
    accelLongitude = longitude;
    locationSource = 'Accelerometer';
  }

  void clearAccelerometerData() {
    accelerometerData = null;
  }
}
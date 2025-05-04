import 'package:geolocator/geolocator.dart';

class LocationModel {
  Position? currentPosition;
  String? errorMessage;

  void updatePosition(Position position) {
    currentPosition = position;
    errorMessage = null;
  }

  void setError(String message) {
    errorMessage = message;
    currentPosition = null;
  }
}
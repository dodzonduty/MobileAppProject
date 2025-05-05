class BusRoute {
  final String title;
  final String subtitle;
  final String startingPoint;
  final String type; // 'bus' or 'minibus'

  BusRoute({
    required this.title,
    required this.subtitle,
    required this.startingPoint,
    required this.type,
  });
}

class MetroRoute {
  final String title;
  final String description;

  MetroRoute({
    required this.title,
    required this.description,
  });
}
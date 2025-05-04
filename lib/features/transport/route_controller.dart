import 'route_model.dart';

class RouteController {
  List<BusRoute> getBusRoutes() {
    return [
      BusRoute(
        title: 'Route 170',
        subtitle: 'Direct to destination',
        startingPoint: 'Ramsis Square',
        type: 'bus',
      ),
      BusRoute(
        title: 'Route 203',
        subtitle: 'Direct to destination',
        startingPoint: 'Tahrir Square',
        type: 'bus',
      ),
      BusRoute(
        title: 'Route 290',
        subtitle: 'Direct to destination',
        startingPoint: 'Nasr City',
        type: 'bus',
      ),
      BusRoute(
        title: 'Route 366',
        subtitle: 'Direct to destination',
        startingPoint: 'Giza Square',
        type: 'bus',
      ),
      BusRoute(
        title: 'Route 917',
        subtitle: 'Direct to destination',
        startingPoint: 'Downtown Cairo',
        type: 'bus',
      ),
      BusRoute(
        title: 'Route 101',
        subtitle: 'Available daily',
        startingPoint: 'Shubra Roundabout',
        type: 'minibus',
      ),
      BusRoute(
        title: 'Route 126',
        subtitle: 'Available daily',
        startingPoint: 'Rod El-Farag',
        type: 'minibus',
      ),
      BusRoute(
        title: 'Route 131',
        subtitle: 'Available daily',
        startingPoint: 'Ahmed Helmy',
        type: 'minibus',
      ),
      BusRoute(
        title: 'Route 159',
        subtitle: 'Available daily',
        startingPoint: 'Koliet El-Zeraa',
        type: 'minibus',
      ),
    ];
  }

  List<MetroRoute> getMetroRoutes() {
    return [
      MetroRoute(
        title: 'El-Marg',
        description:
            'From El-Marg (Line 1), take the metro towards Helwan. Transfer at El-Shohada to Line 2 towards Shubra El-Kheima. Ride 3 stops to El-Khalafawi.',
      ),
      MetroRoute(
        title: 'Hadayek El-Zaytoun',
        description:
            'From Hadayek El-Zaytoun (Line 1), take the metro towards Helwan. Transfer at El-Shohada to Line 2 towards Shubra El-Kheima. Ride 3 stops to El-Khalafawi.',
      ),
      MetroRoute(
        title: 'El-Shohada',
        description:
            'From El-Shohada (Line 1 & 2 interchange), take Line 2 towards Shubra El-Kheima. Ride 3 stops to El-Khalafawi.',
      ),
      MetroRoute(
        title: 'El-Attaba',
        description:
            'From El-Attaba (Line 3), take the metro towards Kit Kat. Transfer at Nasser to Line 2 towards Shubra El-Kheima. Ride 5 stops to El-Khalafawi.',
      ),
      MetroRoute(
        title: 'El-Demerdash',
        description:
            'From El-Demerdash (Line 1), take the metro towards Helwan. Transfer at El-Shohada to Line 2 towards Shubra El-Kheima. Ride 3 stops to El-Khalafawi.',
      ),
      MetroRoute(
        title: 'Saint Teresa',
        description:
            'From Saint Teresa (Line 2), take the metro towards Shubra El-Kheima. Ride 2 stops to El-Khalafawi.',
      ),
      MetroRoute(
        title: 'Faculty of Agriculture',
        description:
            'From Faculty of Agriculture (Line 2), take the metro towards Shubra El-Kheima. Ride 1 stop to El-Khalafawi.',
      ),
      MetroRoute(
        title: 'El-Khalafawi',
        description: 'You are already at El-Khalafawi station (Line 2). No further travel is needed.',
      ),
    ];
  }
}
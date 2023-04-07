import 'package:flutter/material.dart';

class Location {
  final String name;
  final List<double> latlon;

  Location({required this.name, required this.latlon});
}

class LocationProvider extends ChangeNotifier {
  static List<Location> defaultLocations = [
    Location(name: "Mary Avenue Bridge", latlon: [37.3335961, -122.0583445]),
    Location(name: "Caltrans Yard", latlon: [37.3335961, -122.0583445]),
  ];

  List<Location> locations = List.from(defaultLocations);

  void omitFirstLocation() {
    locations.removeAt(0);
    notifyListeners();
  }

  void resetLocations() {
    locations.addAll(defaultLocations.toList());
    notifyListeners();
  }
}

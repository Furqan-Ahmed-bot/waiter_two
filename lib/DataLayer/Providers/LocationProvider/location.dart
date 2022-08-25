import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;


class LocationIdentifier with ChangeNotifier {
  late loc.LocationData _currentLocation;
  Placemark _address = Placemark();
  bool _isLocationMock = false;


  loc.LocationData get currentLocation => _currentLocation;
  bool get isLocationMock => _isLocationMock;
  Placemark get address => _address;

  getLocation() async {
    late bool serviceEnabled;
    late loc.PermissionStatus permissionGranted;
    loc.Location location = loc.Location();

    // Check if location service is enable
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    _currentLocation = locationData;
    _isLocationMock = locationData.isMock!;
    GetAddressFromLatLong(_currentLocation);
    notifyListeners();
  }


  Future<void> GetAddressFromLatLong(loc.LocationData position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude!, position.longitude!);
    Placemark place = placemarks[0];
    _address = place;
  }

}

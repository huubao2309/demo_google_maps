import 'dart:async';

import 'package:demo_google_maps/model/location_maps.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class PickerBloc with ChangeNotifier {
  StreamController<LocationMap> locationController =
      StreamController<LocationMap>.broadcast();
  LocationMap currentLocation;
  static const mapKey = 'AIzaSyA2rYzTXei33nRnHPZLcyAANSuO0hmZLX0';

  static PickerBloc _instance;
  static PickerBloc getInstance() {
    if (_instance == null) {
      _instance = PickerBloc._internal();
    }
    return _instance;
  }

  PickerBloc._internal() {
    // if (currentLocation == null) {
    //   currentLocation = LocationMap()
    //     ..name = 'No Name'
    //     ..formattedAddress = 'No Format'
    //     ..lat = 10.772919
    //     ..lng = 106.696738;
    // }
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<LocationMap>> search(String query) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$mapKey";
    Response response = await Dio().get(url);
    return LocationMap.parseLocationList(response.data);
  }

  void locationSelected(LocationMap location) {
    locationController.sink.add(location);
  }

  void setLocationByMovingMap(LocationMap location) {
    currentLocation = location;
  }

  void dispose() {
    print('close');
    _instance = null;
    locationController.close();
  }
}

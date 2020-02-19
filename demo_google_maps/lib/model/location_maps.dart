class LocationMap {
  String name;
  String formattedAddress;
  double lat;
  double lng;

  LocationMap({this.name, this.formattedAddress, this.lat, this.lng});

  factory LocationMap.fromJson(Map<String, dynamic> map) {
    return LocationMap(
      name: map['name'],
      formattedAddress: map['formatted_address'],
      lat: map['geometry']['location']['lat'],
      lng: map['geometry']['location']['lng'],
    );
  }

  static List<LocationMap> parseLocationList(map) {
    var list = map['results'] as List;
    return list.map((movie) => LocationMap.fromJson(movie)).toList();
  }
}

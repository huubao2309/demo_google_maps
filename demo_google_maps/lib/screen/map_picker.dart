import 'dart:async';

import 'package:demo_google_maps/bloc/picker_bloc.dart';
import 'package:demo_google_maps/model/location_maps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPicker extends StatefulWidget {
  final PickerBloc bloc;
  MapPicker(this.bloc);

  @override
  State<MapPicker> createState() => MapPickerState();
}

class MapPickerState extends State<MapPicker> {
  Completer<GoogleMapController> _controller = Completer();
  // Default Location
  LatLng _target = LatLng(
    10.772919,
    106.696738,
  );

  @override
  void initState() {
    super.initState();
    widget.bloc.locationController.stream.listen(
      (location) async {
        GoogleMapController mapController = await _controller.future;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                await widget.bloc
                    .getCurrentLocation()
                    .then((value) => value.latitude),
                await widget.bloc
                    .getCurrentLocation()
                    .then((value) => value.longitude),
              ),
              zoom: 15.0,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _target,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (CameraPosition newPosition) async {
              widget.bloc.setLocationByMovingMap(LocationMap(
                lat: newPosition.target.latitude,
                lng: newPosition.target.longitude,
              ));
            },
          ),
          Center(
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 45,
            ),
          ),
        ],
      ),
    );
  }
}

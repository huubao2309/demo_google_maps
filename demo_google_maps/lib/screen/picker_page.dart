import 'package:demo_google_maps/bloc/picker_bloc.dart';
import 'package:demo_google_maps/model/location_maps.dart';
import 'package:demo_google_maps/screen/search_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'map_picker.dart';

class MapPickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: ChangeNotifierProvider<PickerBloc>(
        create: (context) => PickerBloc.getInstance(),
        child: MapPickerBody(),
      ),
    );
  }
}

class MapPickerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PickerBloc>(
      builder: (context, bloc, child) => Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                MapPicker(bloc),
                SearchBox(bloc),
              ],
            ),
          ),
          Footer(bloc),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final PickerBloc bloc;
  Footer(this.bloc);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      color: Colors.blue[50],
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.5,
        child: RaisedButton(
          color: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () async {
            // Show Dialog
            await _showInfoLocationDialog(context, bloc.currentLocation);
          },
          child: Text(
            "Show Location",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showInfoLocationDialog(
    BuildContext context, LocationMap locationMap) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(locationMap.name ?? 'No Name'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Format: ' + (locationMap.formattedAddress ?? 'No Format')),
              Text('Latitude: ' + (locationMap.lat.toString() ?? '0.0')),
              Text('Longitude: ' + (locationMap.lng.toString() ?? '0.0')),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

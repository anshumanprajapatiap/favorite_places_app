import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import '../models/placeModel.dart';
import '../screens/mapScreen.dart';

class InputLocation extends StatefulWidget {
  const InputLocation({
    Key? key,
    required this.onSelectLocation,
  }) : super(key: key);
  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag';
  }

  void _savePlace(double lat, double lng) async{
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyDLcwxUggpPZo8lcbH0TB4Crq5SJjtj4ag');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      _isGettingLocation=false;
    });
    //print(locationData.latitude);
    //print(locationData.longitude);
    //print(address);

    widget.onSelectLocation(_pickedLocation!);
  }

  Future<void> _getCurrentLocation() async {


    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation=true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _savePlace(lat, lng);
  }
  _selectOnMap() async{
    final _pickedLocation = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          builder: (Ctx) => MapScreen(),
        )
    );

    if(_pickedLocation==null){
      return;
    }
    _savePlace(_pickedLocation.latitude, _pickedLocation.longitude);
  }
  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if(_isGettingLocation){
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
            )
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocation,
                label: Text("Get Current Location"),
                icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: Text("Select on Map"),
              icon: Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}

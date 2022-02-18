import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key, required this.id, required this.text1}) : super(key: key);
  String id;
  String text1;
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late LocationData _currentPosition;
  late CameraPosition _initialcameraposition;
  Set<Marker> _markers = {};
  List<dynamic> _contacts = [];
  Location geolocation = Location();
  Future getLoc() async {
    var res = await FirebaseFirestore.instance
        .collection('Progress')
        .doc(widget.id)
        .get();
    _contacts = [];
    GeoPoint geoPoint = res['map_location'];
    double lat = geoPoint.latitude;
    double lng = geoPoint.longitude;
    _initialcameraposition = CameraPosition(
      target: LatLng(lng, lat),
      zoom: 14.4746,
    );
    var _id = widget.id;
    LatLng latLng = new LatLng(lng, lat);
    _contacts.add({"location": latLng, "id": _id});

    return _contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Services Maps'),
          backgroundColor: Colors.yellow[800],
        ),
        body: FutureBuilder(
            future: getLoc(),
            builder: (context, snapshot) {
              if (_contacts.isNotEmpty) {
                createMarkers(context);
                return _contacts.isEmpty
                    ? const Center(
                        child: Text('No Locations Founded'),
                      )
                    : Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: _initialcameraposition,
                            markers: _markers,
                            myLocationButtonEnabled: false,
                          ),
                        ],
                      );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  createMarkers(BuildContext context) {
    Marker marker;
    print(_contacts);
    _contacts.forEach((contact) async {
      // marker = Marker(
      //   markerId: MarkerId('house'),
      //   position: contact['location'],
      //   icon: await _getAssetIcon(context).then((value) => value),
      //   infoWindow:
      //       InfoWindow(title: 'house', snippet: 'tap to open', onTap: () {}),
      // );

      // setState(() {
      //   _markers.add(marker);
      // });
      marker = Marker(
        markerId: MarkerId(contact['id']),
        position: contact['location'],
        // icon: await _getAssetIcon(context).then((value) => value),
        infoWindow: InfoWindow(
            title: widget.text1,
            // snippet: 'Tap top Open',
            onTap: () {
              print(contact['id']);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => MapResult(
              //           id: contact['id'],
              //         )));
            }),
      );

      _markers.add(marker);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loca;
import 'package:shared_preferences/shared_preferences.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  _AddLocationState createState() => _AddLocationState();
}

late LatLng po;
Set<Marker> _markers = {};

class _AddLocationState extends State<AddLocation> {
  late CameraPosition _initialcameraposition;
  loca.Location geolocation = loca.Location();

  late LocationData _currentPosition;
  Future getlocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await geolocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await geolocation.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await geolocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await geolocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }

    _currentPosition = await geolocation.getLocation();
    _initialcameraposition = CameraPosition(
      zoom: 10,
      target: LatLng(_currentPosition.latitude!, _currentPosition.longitude!),
    );
    return _initialcameraposition;
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Location'),
        backgroundColor: Colors.yellow[800],
      ),
      body: FutureBuilder(
          future: getlocation(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    markers: _markers,
                    initialCameraPosition: _initialcameraposition,
                    onTap: (value) {
                      setState(() {
                        po = value;
                        _markers.clear();
                        _addMarker();
                      });
                    },
                  ),
                  Positioned(
                      bottom: 50,
                      right: 130,
                      child: TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.only(
                                      top: height / 45,
                                      bottom: height / 45,
                                      left: width / 10,
                                      right: width / 10)),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.yellow[800],
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(
                                        color: Colors.yellow[800]!,
                                      )))),
                          child: const Text(
                            'Save Position',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () => _save()))
                ],
              );
            }
          }),
    );
  }

  _addMarker() {
    var marker = Marker(
      position: po,
      icon: BitmapDescriptor.defaultMarker,
      markerId: const MarkerId('1'),
    );
    setState(() {
      _markers.add(marker);
      print(_markers);
    });
  }

  _save() async {
    setState(() {
      showLoadingDialog(context);
    });
    if (po == null) {
      Navigator.of(context).pop();
      showBar(context, 'you must add location', 0);
    } else {
      final prefs = await SharedPreferences.getInstance();
      double lat = po.latitude;
      double lon = po.longitude;
      print(lon);
      await prefs.setDouble('lat', lat);
      await prefs.setDouble('lon', lon);
      _markers.clear();
      Navigator.of(context).pop();
      showBar(context, 'location added !!!', 1);
    }
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }
}

                                                          

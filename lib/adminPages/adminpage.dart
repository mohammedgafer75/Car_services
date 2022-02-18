import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AminPanel extends StatefulWidget {
  AminPanel({Key? key}) : super(key: key);

  @override
  _AminPanelState createState() => _AminPanelState();
}

class _AminPanelState extends State<AminPanel> {
  bool ch = false;
  TextEditingController det = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: height / 80,
        ),
        padding: EdgeInsets.only(
            top: height / 90, left: width / 8, right: width / 8),
        child: Center(
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: [
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Battery Repair'),
                          content: TextFormField(
                            // controller: det,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "please enter your email";
                              }
                            },
                            decoration: const InputDecoration(
                                hintText: "some details about your car"),
                          ),
                          actions: [
                            // SwitchListTile(
                            //     title: const Text('Send Current Location'),
                            //     value: ch,
                            //     onChanged: (bool value) {
                            //       setState(() {
                            //         ch = value;
                            //       });
                            //     }),
                            TextButton(
                                onPressed: () async {
                                  // if (_formKey.currentState!.validate()) {
                                  //   setState(() {
                                  //     showLoadingDialog(context);
                                  //   });
                                  //   auth.User? user =
                                  //       FirebaseAuth.instance.currentUser;
                                  //   String? name = user!.displayName;
                                  //   // double? la = _currentPosition.latitude;
                                  //   //  double? lo = _currentPosition.longitude;
                                  //   GeoPoint location = GeoPoint(10, 16);
                                  //   var res = await addItem(
                                  //       uid: user.uid,
                                  //       name: name!,
                                  //       type: 'Battery Repair',
                                  //       description: det.text.trim(),
                                  //       map_location: location);
                                  //   if (res.ch == 1) {
                                  //     setState(() {
                                  //       det.clear();
                                  //       Navigator.of(context).pop();
                                  //       showBar(
                                  //           context, "Progress Added!!", 1);
                                  //     });
                                  //   } else {
                                  //     setState(() {
                                  //       Navigator.of(context).pop();
                                  //       showBar(context, res.data, 0);
                                  //     });
                                  //   }
                                  // }
                                },
                                child: const Text('Send report'))
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.yellow[900],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Center(
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/bat.jpg'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Battery Repair',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Wheels Repair'),
                          content: TextFormField(
                            //  controller: det,
                            decoration: const InputDecoration(
                                hintText: "some details about your car"),
                          ),
                          actions: [
                            // SwitchListTile(
                            //     title: const Text('Send Current Location'),
                            //     value: ch,
                            //     onChanged: (bool value) {
                            //       setState(() {
                            //         ch = value;
                            //       });
                            //     }),
                            TextButton(
                                onPressed: () async {
                                  // setState(() {
                                  //   showLoadingDialog(context);
                                  // });
                                  // auth.User? user =
                                  //     FirebaseAuth.instance.currentUser;
                                  // String? name = user!.displayName;
                                  // double? la = _currentPosition.latitude;
                                  // double? lo = _currentPosition.longitude;
                                  // GeoPoint location = GeoPoint(la!, lo!);
                                  // var res = await addItem(
                                  //     uid: user.uid,
                                  //     name: name!,
                                  //     type: 'Wheels Repair',
                                  //     description: det.text.trim(),
                                  //     map_location: location);
                                  // if (res.ch == 1) {
                                  //   setState(() {
                                  //     det.clear();
                                  //     Navigator.of(context).pop();
                                  //     showBar(context, "Progress Added!!", 1);
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     Navigator.of(context).pop();
                                  //     showBar(context, res.data, 0);
                                  //   });
                                  // }
                                },
                                child: const Text('Send report'))
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.yellow[900],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Center(
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/wh.png'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Wheels Repair',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Engine Repair'),
                          content: TextFormField(
                            // controller: det,
                            decoration: const InputDecoration(
                                hintText: "some details about your car"),
                          ),
                          actions: [
                            // SwitchListTile(
                            //     title: const Text('Send Current Location'),
                            //     value: ch,
                            //     onChanged: (bool value) {
                            //       setState(() {
                            //         ch = value;
                            //       });
                            //     }),
                            TextButton(
                                onPressed: () async {
                                  // setState(() {
                                  //   showLoadingDialog(context);
                                  // });
                                  // auth.User? user =
                                  //     FirebaseAuth.instance.currentUser;
                                  // String? name = user!.displayName;
                                  // double? la = _currentPosition.latitude;
                                  // double? lo = _currentPosition.longitude;
                                  // GeoPoint location = GeoPoint(la!, lo!);
                                  // var res = await addItem(
                                  //     uid: user.uid,
                                  //     name: name!,
                                  //     type: 'Engine Repair',
                                  //     description: det.text.trim(),
                                  //     map_location: location);
                                  // if (res.ch == 1) {
                                  //   setState(() {
                                  //     det.clear();
                                  //     Navigator.of(context).pop();
                                  //     showBar(context, "Progress Added!!", 1);
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     Navigator.of(context).pop();
                                  //     showBar(context, res.data, 0);
                                  //   });
                                  // }
                                },
                                child: const Text('Send report'))
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.yellow[900],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Center(
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/ac.png'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Engine Repair',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Car Accessories'),
                          content: TextFormField(
                            //  controller: det,
                            decoration: const InputDecoration(
                                hintText: "some details about your car"),
                          ),
                          actions: [
                            // SwitchListTile(
                            //     title: const Text('Send Current Location'),
                            //     value: ch,
                            //     onChanged: (bool value) {
                            //       setState(() {
                            //         ch = value;
                            //       });
                            //     }),
                            TextButton(
                                onPressed: () async {
                                  // setState(() {
                                  //   showLoadingDialog(context);
                                  // });
                                  // auth.User? user =
                                  //     FirebaseAuth.instance.currentUser;
                                  // String? name = user!.displayName;
                                  // double? la = _currentPosition.latitude;
                                  // double? lo = _currentPosition.longitude;
                                  // GeoPoint location = GeoPoint(la!, lo!);
                                  // var res = await addItem(
                                  //     uid: user.uid,
                                  //     name: name!,
                                  //     type: 'Car Accessories',
                                  //     description: det.text.trim(),
                                  //     map_location: location);
                                  // if (res.ch == 1) {
                                  //   setState(() {
                                  //     det.clear();
                                  //     Navigator.of(context).pop();
                                  //     showBar(context, "Progress Added!!", 1);
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     Navigator.of(context).pop();
                                  //     showBar(context, res.data, 0);
                                  //   });
                                  // }
                                },
                                child: const Text('Send report'))
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: Colors.yellow[900],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Center(
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/ac.png'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Car Accessories',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    launch('tel://65782');
                  },
                  child: Card(
                    color: Colors.yellow[900],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          Center(
                            child: CircleAvatar(
                              maxRadius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/hot.jpg'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Hot Line',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
    ;
  }
}

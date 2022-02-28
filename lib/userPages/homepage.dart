import 'package:car_services/adminPages/admin_home_page.dart';
import 'package:car_services/userPages/add_workshop.dart';
import 'package:car_services/userPages/myworkshop.dart';
import 'package:car_services/userPages/progress_page.dart';
import 'package:car_services/userPages/user_progress.dart';
import 'package:car_services/userPages/user_services_page.dart';
import 'package:car_services/userPages/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loca;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

bool _value = false;

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    getlocation();
  }

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
    return _currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Progress')
            .where('workerid', isEqualTo: user!.uid)
            .where('status', isEqualTo: 0)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Worker Panel'),
                backgroundColor: Colors.yellow[800],
                actions: [
                  IconBadge(
                    icon: const Icon(Icons.notifications_none),
                    itemCount: snapshot.data!.docs.length,
                    badgeColor: Colors.red,
                    itemColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProgressPage()));
                    },
                  ),
                ],
              ),
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Worker')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            top: height / 50,
                            left: width / 8,
                            right: width / 8),
                        child: Column(
                          children: [
                            SwitchListTile(
                              value: snapshot.data!.docs[0]['status'],
                              onChanged: (value) async {
                                setState(() {
                                  showAboutDialog(context: context);
                                });
                                var progress = await FirebaseFirestore.instance
                                    .collection('Progress')
                                    .where('workerid', isEqualTo: user.uid)
                                    .get();
                                int a = 0;
                                for (var item in progress.docs) {
                                  if (item['status'] == 0) {
                                    a = 1;
                                  }
                                }
                                if (a == 0) {
                                  var userWallet = await FirebaseFirestore
                                      .instance
                                      .collection('workerwallet')
                                      .where('uid', isEqualTo: user.uid)
                                      .get();
                                  var userworkshop = await FirebaseFirestore
                                      .instance
                                      .collection('workshop')
                                      .where('uid', isEqualTo: user.uid)
                                      .get();
                                  for (var item in userworkshop.docs) {
                                    int? month =
                                        int.tryParse(item['month'].toString());
                                    if (month! + 1 == DateTime.now().month) {
                                      await FirebaseFirestore.instance
                                          .collection('workshop')
                                          .doc(item.id)
                                          .update({'status': 0});
                                    }
                                  }

                                  if (userWallet.docs[0]['request'] != 0) {
                                    double? lat = _currentPosition.latitude;
                                    double? lon = _currentPosition.longitude;
                                    LatLng po = LatLng(lat!, lon!);

                                    _value = value;
                                    await FirebaseFirestore.instance
                                        .collection('Worker')
                                        .doc(snapshot.data!.docs[0].id)
                                        .update({
                                      'status': value,
                                      'location': GeoPoint(lat, lon)
                                    });

                                    setState(() {
                                      Navigator.of(context).pop();
                                    });
                                  } else {
                                    setState(() {
                                      Navigator.of(context).pop();
                                      showBar(
                                          context, 'you dont have a wallet', 0);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    showBar(context, 'you  have a Progress', 0);
                                  });
                                }
                              },
                              title: !snapshot.data!.docs[0]['status']
                                  ? const Text('OffLine')
                                  : const Text('OnLine'),
                            ),
                            // ListTileSwitch(
                            //   value: snapshot.data!.docs[0]['status'],
                            //   onChanged: (value) async {
                            //     setState(() {
                            //       showAboutDialog(context: context);
                            //     });
                            //     var progress = await FirebaseFirestore.instance
                            //         .collection('Progress')
                            //         .where('workerid', isEqualTo: user.uid)
                            //         .get();
                            //     int a = 0;
                            //     for (var item in progress.docs) {
                            //       if (item['status'] == 0) {
                            //         a = 1;
                            //       }
                            //     }
                            //     if (a == 0) {
                            //       var userWallet = await FirebaseFirestore
                            //           .instance
                            //           .collection('workerwallet')
                            //           .where('uid', isEqualTo: user.uid)
                            //           .get();
                            //       var userworkshop = await FirebaseFirestore
                            //           .instance
                            //           .collection('workshop')
                            //           .where('uid', isEqualTo: user.uid)
                            //           .get();
                            //       for (var item in userworkshop.docs) {
                            //         int? month =
                            //             int.tryParse(item['month'].toString());
                            //         if (month! + 1 == DateTime.now().month) {
                            //           await FirebaseFirestore.instance
                            //               .collection('workshop')
                            //               .doc(item.id)
                            //               .update({'status': 0});
                            //         }
                            //       }

                            //       if (userWallet.docs[0]['request'] != 0) {
                            //         double? lat = _currentPosition.latitude;
                            //         double? lon = _currentPosition.longitude;
                            //         LatLng po = LatLng(lat!, lon!);

                            //         _value = value;
                            //         await FirebaseFirestore.instance
                            //             .collection('Worker')
                            //             .doc(snapshot.data!.docs[0].id)
                            //             .update({
                            //           'status': value,
                            //           'location': GeoPoint(lat, lon)
                            //         });

                            //         setState(() {
                            //           Navigator.of(context).pop();
                            //         });
                            //       } else {
                            //         setState(() {
                            //           Navigator.of(context).pop();
                            //           showBar(
                            //               context, 'you dont have a wallet', 0);
                            //         });
                            //       }
                            //     } else {
                            //       setState(() {
                            //         Navigator.of(context).pop();
                            //         showBar(context, 'you  have a Progress', 0);
                            //       });
                            //     }
                            //   },
                            //   visualDensity: VisualDensity.comfortable,
                            //   switchType: SwitchType.cupertino,
                            //   switchActiveColor: Colors.indigo,
                            //   title: !snapshot.data!.docs[0]['status']
                            //       ? const Text('OffLine')
                            //       : const Text('OnLine'),
                            // ),
                            Container(
                              padding: const EdgeInsets.only(top: 80),
                              height: 400,
                              width: 300,
                              child: Center(
                                child: GridView.count(
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    crossAxisCount: 2,
                                    childAspectRatio: .90,
                                    children: const [
                                      // Card_d(
                                      //   icon: const Icon(
                                      //       Icons.change_circle_outlined,
                                      //       size: 30,
                                      //       color: Colors.white),
                                      //   title: 'Progress Page',
                                      //   nav: ProgressPage(),
                                      // ),
                                      Card_d(
                                        icon: Icon(Icons.money,
                                            size: 30, color: Colors.white),
                                        title: 'Wallet Page',
                                        nav: Wallet(),
                                      ),
                                      Card_d(
                                        icon: Icon(Icons.work,
                                            size: 30, color: Colors.white),
                                        title: 'My WorkShop',
                                        nav: MyWorkshop(),
                                      ),
                                      Card_d(
                                        icon: Icon(Icons.add_box,
                                            size: 30, color: Colors.white),
                                        title: 'Add WorkShop',
                                        nav: AddWorkshop(),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            );
          }
        });
  }

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }
}

class Card_d extends StatefulWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final dynamic icon;
  final dynamic nav;

  @override
  State<Card_d> createState() => _Card_dState();
}

// ignore: camel_case_types
class _Card_dState extends State<Card_d> {
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.nav));
      },
      child: Card(
        color: const Color.fromRGBO(19, 26, 44, 1.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: widget.icon),
              const SizedBox(
                height: 10,
              ),
              Text(widget.title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

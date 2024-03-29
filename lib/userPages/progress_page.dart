import 'package:car_services/userPages/add_wallet.dart';
import 'package:car_services/userPages/google_map_page.dart';
import 'package:car_services/http.dart';
import 'package:car_services/userPages/user_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/instance_manager.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loca;
import 'package:car_services/sign_in.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class ProgressPage extends StatefulWidget {
  ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPage createState() => _ProgressPage();
}

class _ProgressPage extends State<ProgressPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool ch = false;
  TextEditingController det = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int count = 0;
  late LocationData _currentPosition;
  loca.Location geolocation = loca.Location();
  Future getData() async {
    print(count);
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

    var res = await FirebaseFirestore.instance.collection('Car_Care').get();
    int len = res.docs.length;
    setState(() {
      count = len;
    });
    print(count);
    return count;
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Progress')
            .where('workerid', isEqualTo: user!.uid)
            .where('status', isEqualTo: 1)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Services'),
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
              backgroundColor: Colors.white,
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('wallet')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data!.docs.isNotEmpty) {
                        var bal = snapshot.data!.docs[0]['balance'];
                        var id = snapshot.data!.docs[0].id;
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Progress')
                                .where('status', isEqualTo: 0)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ExpansionTileCard(
                                                title: Text(
                                                    '${snapshot.data!.docs[index]['type']}'),
                                                subtitle: const Text(
                                                    'tab to get more information'),
                                                children: <Widget>[
                                                  const Divider(
                                                    thickness: 1.0,
                                                    height: 1.0,
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 16.0,
                                                          vertical: 8.0,
                                                        ),
                                                        child: Text(snapshot
                                                                .data!
                                                                .docs[index]
                                                            ['description']),
                                                      )),
                                                  Row(
                                                    children: [
                                                      ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        buttonHeight: 52.0,
                                                        buttonMinWidth: 90.0,
                                                        children: [
                                                          TextButton(
                                                              style:
                                                                  flatButtonStyle,
                                                              onPressed:
                                                                  () async {
                                                                Navigator.of(context).push(MaterialPageRoute(
                                                                    builder: (BuildContext context) => MapPage(
                                                                        id: snapshot
                                                                            .data!
                                                                            .docs[
                                                                                index]
                                                                            .id,
                                                                        text1: snapshot
                                                                            .data!
                                                                            .docs[index]['type'])));
                                                              },
                                                              child: Column(
                                                                children: const <
                                                                    Widget>[
                                                                  Icon(Icons
                                                                      .map),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            2.0),
                                                                  ),
                                                                  Text(
                                                                      'Open on Map'),
                                                                ],
                                                              )),
                                                          ButtonBar(
                                                            alignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            buttonHeight: 52.0,
                                                            buttonMinWidth:
                                                                90.0,
                                                            children: [
                                                              TextButton(
                                                                  style:
                                                                      flatButtonStyle,
                                                                  onPressed:
                                                                      () async {
                                                                    auth.User?
                                                                        user =
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser;
                                                                    String?
                                                                        name =
                                                                        user!
                                                                            .displayName;

                                                                    setState(
                                                                        () {
                                                                      showLoadingDialog(
                                                                          context);
                                                                    });
                                                                    var res1 = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Worker')
                                                                        .where(
                                                                            'uid',
                                                                            isEqualTo:
                                                                                user.uid)
                                                                        .get();
                                                                    List<String>
                                                                        numbers =
                                                                        [];
                                                                    res1.docs
                                                                        .forEach(
                                                                            (element) {
                                                                      numbers.add(
                                                                          element[
                                                                              'phone']);
                                                                    });
                                                                    String
                                                                        number =
                                                                        numbers[
                                                                            0];
                                                                    var res = await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'wallet')
                                                                        .where(
                                                                            'uid',
                                                                            isEqualTo:
                                                                                user.uid)
                                                                        .get();
                                                                    if (res.docs[0]
                                                                            [
                                                                            'request'] <
                                                                        1) {
                                                                      setState(
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        showBar(
                                                                            context,
                                                                            'you dont have abalance',
                                                                            0);
                                                                      });
                                                                    } else {
                                                                      try {
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('Progress')
                                                                            .doc(snapshot.data!.docs[index].id)
                                                                            .update({
                                                                          'workername':
                                                                              name,
                                                                          'worker_number':
                                                                              number,
                                                                          'workerid':
                                                                              user.uid,
                                                                          'status':
                                                                              1,
                                                                        });

                                                                        setState(
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();

                                                                          showBar(
                                                                              context,
                                                                              "Request Accepted check your progress",
                                                                              1);
                                                                        });
                                                                      } catch (e) {
                                                                        print(e
                                                                            .toString());
                                                                        setState(
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          showBar(
                                                                              context,
                                                                              'somethings wrong',
                                                                              0);
                                                                        });
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Column(
                                                                    children: const <
                                                                        Widget>[
                                                                      Icon(Icons
                                                                          .accessibility),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 2.0),
                                                                      ),
                                                                      Text(
                                                                          'Accept Request'),
                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ]));
                                      });
                                } else {
                                  return const Center(
                                      child: Text('No Available User request'));
                                }
                              }
                            });
                      } else {
                        return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('You Dont have a wallet !!!'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddWallet()));
                                    },
                                    child: const Text('make wallet'))
                              ]),
                        );
                      }
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
}

class Card_d extends StatefulWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final String icon;
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
      onTap: () async {
        Alert(
          context: context,
        );
      },
      child: Card(
        color: const Color.fromRGBO(19, 26, 44, 1.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  maxRadius: 70,
                  backgroundImage: AssetImage(widget.icon),
                ),
              ),
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

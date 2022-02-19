import 'package:car_services/userPages/add_location.dart';
import 'package:car_services/userPages/google_map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWorkshop extends StatefulWidget {
  const AddWorkshop({Key? key}) : super(key: key);

  @override
  _AddWorkshopState createState() => _AddWorkshopState();
}

TextEditingController name = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _AddWorkshopState extends State<AddWorkshop> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add WorkShop'),
          backgroundColor: Colors.yellow[800],
        ),
        backgroundColor: Color.fromRGBO(19, 26, 44, 1.0),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('SubscriptionFee')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var bal = snapshot.data!.docs[0]['WorkShop'];
                    return ListView(
                      padding: EdgeInsets.only(top: height * 0.05),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                              'Subscription fee of Workshop: ${snapshot.data!.docs[0]['WorkShop']}',
                              style: const TextStyle(
                                  fontSize: 20.0, color: Colors.white)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            padding: EdgeInsets.only(
                                right: width / 8, left: width / 8),
                            height: height * 0.1,
                            width: width * 1.0,
                            child: TextFormField(
                              controller: name,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "please enter your workshop Name";
                                }
                              },
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 3.0),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70.withOpacity(.7),
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(13),
                                ),

                                labelText: 'WokerShop Name',

                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                hintStyle: const TextStyle(color: Colors.white),

                                // hintText: hint,
                                //  hintStyle: kBodyText,
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Center(
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
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  19, 26, 44, 1.0))))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddLocation()));
                              },
                              child: const Text(
                                'Add Location',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
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
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  19, 26, 44, 1.0))))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  auth.User? user =
                                      FirebaseAuth.instance.currentUser;

                                  setState(() {
                                    showLoadingDialog(context);
                                  });
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  double? lon = prefs.getDouble('lon');
                                  double? lat = prefs.getDouble('lat');
                                  print(lon);
                                  var res1 = await FirebaseFirestore.instance
                                      .collection('workerwallet')
                                      .where('uid', isEqualTo: user!.uid)
                                      .get();
                                  if (res1.docs.isNotEmpty) {
                                    var id = res1.docs[0].id;
                                    if (res1.docs[0]['balance'] < bal) {
                                      setState(() {
                                        Navigator.of(context).pop();
                                        showBar(context,
                                            'you dont have abalance', 0);
                                      });
                                    } else {
                                      if (lon != null || lat != null) {
                                        var res = await FirebaseFirestore
                                            .instance
                                            .collection('Worker')
                                            .where('uid', isEqualTo: user.uid)
                                            .get();

                                        List<String> numbers = [];
                                        res.docs.forEach((element) {
                                          numbers.add(element['phone']);
                                        });
                                        String number = numbers[0];
                                        GeoPoint location =
                                            GeoPoint(lat!, lon!);
                                        Map<String, dynamic> data =
                                            <String, dynamic>{
                                          "uid": user.uid,
                                          "phone": number,
                                          "username": user.displayName,
                                          "workshopName": name.text,
                                          'day': DateTime.now().day,
                                          'month': DateTime.now().month,
                                          'year': DateTime.now().year,
                                          "location": location,
                                          "status": 0,
                                        };

                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('workshop')
                                              .doc()
                                              .set(data);
                                          await FirebaseFirestore.instance
                                              .collection('workerwallet')
                                              .doc(id)
                                              .update({
                                            'balance':
                                                res1.docs[0]['balance'] - bal
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('adminwallet')
                                              .doc()
                                              .set({
                                            'workerid': user.uid,
                                            'day': DateTime.now().day,
                                            'balance': bal
                                          });
                                          await prefs.remove('lon');
                                          await prefs.remove('lat');
                                          setState(() {
                                            Navigator.of(context).pop();
                                            showBar(
                                                context,
                                                "WorkShop Added !! Watiting admin accept",
                                                1);
                                          });
                                        } catch (e) {
                                          setState(() {
                                            Navigator.of(context).pop();
                                            showBar(context, e.toString(), 0);
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          Navigator.of(context).pop();
                                          showBar(context,
                                              'you must add location', 0);
                                        });
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      Navigator.of(context).pop();
                                      showBar(
                                          context, 'you dont have a wallet', 0);
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ),
        ));
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

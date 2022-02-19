import 'package:car_services/userPages/add_workshop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyWorkshop extends StatefulWidget {
  const MyWorkshop({Key? key}) : super(key: key);

  @override
  _MyWorkshop createState() => _MyWorkshop();
}

class _MyWorkshop extends State<MyWorkshop> {
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My WorkShop'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddWorkshop()));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('workshop')
              .where('uid', isEqualTo: user!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No data Founded'),
                );
              } else {
                var time = DateTime.now().add(const Duration(days: 30));
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: SizedBox(
                            height: 130,
                            width: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Workershop Name: ${snapshot.data!.docs[index]['name']}'),
                                const SizedBox(
                                  height: 5,
                                ),
                                snapshot.data!.docs[index]['status'] == 0
                                    ? const Text('Not accepted by admin')
                                    : const Text('Accepted by Admin'),
                                snapshot.data!.docs[index]['status'] == 0
                                    ? const SizedBox()
                                    : Text(
                                        'Expired time: ${snapshot.data!.docs[index]['day']}/${snapshot.data!.docs[index]['month'] + 1}/${snapshot.data!.docs[index]['year']}'),
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
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.yellow[800],
                                            ),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    side: const BorderSide(
                                                        color: Color.fromRGBO(
                                                            19,
                                                            26,
                                                            44,
                                                            1.0))))),
                                        onPressed: () async {
                                          Alert(
                                              title: 'New subscription',
                                              context: context,
                                              content: Text('Price: 500 SDG'),
                                              buttons: [
                                                DialogButton(
                                                    child: Text('Save'),
                                                    onPressed: () async {
                                                      setState(() {
                                                        showLoadingDialog(
                                                            context);
                                                      });
                                                      var res1 =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'workerwallet')
                                                              .where('uid',
                                                                  isEqualTo:
                                                                      user.uid)
                                                              .get();
                                                      if (res1
                                                          .docs.isNotEmpty) {
                                                        var id =
                                                            res1.docs[0].id;
                                                        if (res1.docs[0]
                                                                ['balance'] <
                                                            500) {
                                                          setState(() {
                                                            Navigator.of(
                                                                    context)
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
                                                                .collection(
                                                                    'workerwallet')
                                                                .doc(id)
                                                                .update({
                                                              'balance': res1
                                                                          .docs[0]
                                                                      [
                                                                      'balance'] -
                                                                  500
                                                            });
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'workshop')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id)
                                                                .update({
                                                              'status': true,
                                                              'day':
                                                                  DateTime.now()
                                                                      .day,
                                                              'month':
                                                                  DateTime.now()
                                                                      .month,
                                                              'year':
                                                                  DateTime.now()
                                                                      .year,
                                                            });
                                                            setState(() {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              showBar(
                                                                  context,
                                                                  'You have a New subscription',
                                                                  1);
                                                            });
                                                          } catch (e) {
                                                            setState(() {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              showBar(
                                                                  context,
                                                                  e.toString(),
                                                                  0);
                                                            });
                                                          }
                                                        }
                                                      } else {
                                                        setState(() {
                                                          Navigator.of(context)
                                                              .pop();
                                                          showBar(
                                                              context,
                                                              'you dont have a wallet',
                                                              0);
                                                        });
                                                      }
                                                    })
                                              ]).show();
                                        },
                                        child: const Text(
                                          'New subscription',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ));
                    });
              }
            }
          }),
    );
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

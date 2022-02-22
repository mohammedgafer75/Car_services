import 'package:car_services/userPages/google_map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UserProgressPage extends StatefulWidget {
  UserProgressPage({Key? key}) : super(key: key);

  @override
  _UserProgressPage createState() => _UserProgressPage();
}

class _UserProgressPage extends State<UserProgressPage> {
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    String? name = user!.displayName;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your current Progress'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Progress')
              .where('workerid', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No available request ',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: SizedBox(
                            height: 190,
                            width: 70,
                            child: ListView(children: [
                              Center(
                                child: Text(
                                  '${snapshot.data!.docs[index]['type']} In Progress ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                    'Owner Request: ${snapshot.data!.docs[index]['name']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                    'Price: ${snapshot.data!.docs[index]['price']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Text(
                                    'Information: ${snapshot.data!.docs[index]['description']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              snapshot.data!.docs[index]['status'] == 0
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.only(top: 18, left: 18),
                                      child: Text('Status: waiting',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    )
                                  : snapshot.data!.docs[index]['status'] == 1
                                      ? const Padding(
                                          padding: EdgeInsets.only(
                                              top: 18, left: 18),
                                          child: Text('Status: Done',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.only(
                                              top: 18, left: 18),
                                          child: Text('Status: Cancled',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                        ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    snapshot.data!.docs[index]['status'] == 0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty.all(
                                                            const EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10,
                                                                left: 15,
                                                                right: 15)),
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            const Color.fromRGBO(
                                                                19, 26, 44, 1.0)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(13),
                                                            side: const BorderSide(color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              MapPage(
                                                                  id: snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id,
                                                                  text1: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'type'])));
                                                },
                                                child: const Text(
                                                  'Open in Map',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    snapshot.data!.docs[index]['status'] == 0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty.all(
                                                            const EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10,
                                                                left: 15,
                                                                right: 15)),
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            const Color.fromRGBO(
                                                                19, 26, 44, 1.0)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(13),
                                                            side: const BorderSide(color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                                onPressed: () async {
                                                  setState(() {
                                                    showLoadingDialog(context);
                                                  });
                                                  try {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Progress')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .update({
                                                      'status': 2,
                                                    });
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showBar(
                                                          context,
                                                          "Progress Canceled",
                                                          1);
                                                    });
                                                  } catch (e) {
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showBar(context,
                                                          e.toString(), 0);
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    snapshot.data!.docs[index]['status'] == 0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStateProperty.all(
                                                            const EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10,
                                                                left: 15,
                                                                right: 15)),
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            const Color.fromRGBO(
                                                                19, 26, 44, 1.0)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(13),
                                                            side: const BorderSide(color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                                onPressed: () async {
                                                  setState(() {
                                                    showLoadingDialog(context);
                                                  });
                                                  try {
                                                    var userid = snapshot.data!
                                                        .docs[index]['uid'];
                                                    var workerid = snapshot
                                                            .data!.docs[index]
                                                        ['workerid'];
                                                    var userWallet =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'userwallet')
                                                            .where('uid',
                                                                isEqualTo:
                                                                    userid)
                                                            .get();
                                                    var newbal =
                                                        userWallet.docs[0]
                                                                ['balance'] -
                                                            100;
                                                    var workerWallet =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'workerwallet')
                                                            .where('uid',
                                                                isEqualTo:
                                                                    workerid)
                                                            .get();
                                                    var newrequest =
                                                        workerWallet.docs[0]
                                                                ['request'] -
                                                            1;
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'userwallet')
                                                        .doc(userWallet
                                                            .docs[0].id)
                                                        .update({
                                                      'balance': newbal
                                                    });
                                                    if (newrequest <= 0) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'workerwallet')
                                                          .doc(workerWallet
                                                              .docs[0].id)
                                                          .update({
                                                        'request': 0,
                                                        'status': false
                                                      });
                                                    } else {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'workerwallet')
                                                          .doc(workerWallet
                                                              .docs[0].id)
                                                          .update({
                                                        'request': newrequest
                                                      });
                                                    }

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'adminwallet')
                                                        .doc()
                                                        .set({
                                                      'workerid': user.uid,
                                                      'day': DateTime.now().day,
                                                      'year': DateTime.now().year,
                                                      'month':
                                                          DateTime.now().month,
                                                      'balance': 100
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Progress')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .update({
                                                      'status': 1,
                                                    });
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showBar(context,
                                                          "Progress Done", 1);
                                                    });
                                                  } catch (e) {
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showBar(context,
                                                          e.toString(), 0);
                                                    });
                                                  }
                                                },
                                                child: const Text(
                                                  'Done',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          )
                                        : const SizedBox()
                                  ])
                            ]),
                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
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

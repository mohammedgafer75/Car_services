import 'package:car_services/google_map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    String? name = user!.displayName;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Your current Progress'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Progress')
              .where('worker', isEqualTo: name)
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
                            height: 130,
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
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 15,
                                                right: 15)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    19, 26, 44, 1.0)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                side: const BorderSide(
                                                    color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  MapPage(
                                                      id: snapshot
                                                          .data!.docs[index].id,
                                                      text1: snapshot
                                                              .data!.docs[index]
                                                          ['type'])));
                                    },
                                    child: const Text(
                                      'Open in Map',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: TextButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.only(
                                                top: 10,
                                                bottom: 10,
                                                left: 15,
                                                right: 15)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    19, 26, 44, 1.0)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                side: const BorderSide(
                                                    color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                    onPressed: () async {
                                      try {
                                        var res = await FirebaseFirestore
                                            .instance
                                            .collection('Progress')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({'status': 2,'worker':''});
                                        setState(() {
                                          showBar(
                                              context, "Progress Canceled", 1);
                                        });
                                      } catch (e) {
                                        setState(() {
                                          showBar(context, e.toString(), 0);
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                                  ]))
                              
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
}

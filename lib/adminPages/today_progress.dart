import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodayProgress extends StatefulWidget {
  const TodayProgress({Key? key}) : super(key: key);

  @override
  _TodayProgressState createState() => _TodayProgressState();
}

class _TodayProgressState extends State<TodayProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today Progress'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Progress')
              .where('time', isEqualTo: DateTime.now().day)
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
                            height: 150,
                            width: 70,
                            child: ListView(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    '${snapshot.data!.docs[index]['type']} Services ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      ' Maintenance worker: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      ' ${snapshot.data!.docs[index]['worker']} ',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      ' User: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      ' ${snapshot.data!.docs[index]['name']} ',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      ' Status: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    snapshot.data!.docs[index]['status'] == 1
                                        ? const Text(
                                            ' Done',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          )
                                        : snapshot.data!.docs[index]
                                                    ['status'] ==
                                                0
                                            ? const Text(
                                                ' Waiting ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              )
                                            : const Text(
                                                ' Cancled ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                  ],
                                ),
                              ),
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
}

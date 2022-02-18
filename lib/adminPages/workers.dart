import 'package:car_services/adminPages/worker_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Workers extends StatefulWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  _WorkersState createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workers'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Worker').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
            if (!snapshot1.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot1.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No data Founded'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot1.data!.docs.length,
                    itemBuilder: (BuildContext context, index) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('workerwallet')
                              .where('uid',
                                  isEqualTo: snapshot1.data!.docs[index]['uid'])
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              int bal = 0;
                              snapshot.data!.docs.forEach((element) {
                                int b = element['balance'];
                                bal += b;
                              });
                              return ExpansionTile(
                                iconColor: Colors.yellow[800],
                                textColor: Colors.yellow[800],
                                // collapsedTextColor: Colors.yellow[800],
                                leading: const Icon(Icons.person),
                                title: Text(
                                    '${snapshot1.data!.docs[index]['name']}'),
                                subtitle: const Text(
                                    'tap to open get more information'),
                                children: [
                                  Column(
                                    children: [
                                      Text('profit from the worker: $bal'),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WorkerProgress(
                                                            name: snapshot1
                                                                    .data!
                                                                    .docs[index]
                                                                ['uid'])));
                                          },
                                          child: const Text('Worker progress'))
                                    ],
                                  )
                                ],
                              );
                            }
                          });
                    });
              }
            }
          }),
    );
  }
}

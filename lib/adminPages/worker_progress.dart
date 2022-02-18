import 'package:car_services/userPages/google_map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkerProgress extends StatefulWidget {
  const WorkerProgress({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  _WorkerProgress createState() => _WorkerProgress();
}

class _WorkerProgress extends State<WorkerProgress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Worker Progress'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Progress')
              .where('workerid', isEqualTo: widget.name)
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
                              snapshot.data!.docs[index]['status'] == 1
                                  ? const Text('Done',
                                      style:
                                          TextStyle(color: Colors.greenAccent))
                                  : snapshot.data!.docs[index]['status'] == 3
                                      ? const Text('Cancled',
                                          style: TextStyle(color: Colors.red))
                                      : const Text('wating',
                                          style:
                                              TextStyle(color: Colors.black)),
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

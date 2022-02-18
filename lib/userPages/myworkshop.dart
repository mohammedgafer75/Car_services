import 'package:car_services/userPages/add_workshop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class MyWorkshop extends StatefulWidget {
  const MyWorkshop({Key? key}) : super(key: key);

  @override
  _MyWorkshop createState() => _MyWorkshop();
}

class _MyWorkshop extends State<MyWorkshop> {
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
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
                                        'Expired time: ${snapshot.data!.docs[index]['expired time']}')
                              ],
                            ),
                          ));
                    });
              }
            }
          }),
    );
  }
}

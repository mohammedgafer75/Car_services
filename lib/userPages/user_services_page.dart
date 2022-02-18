import 'package:car_services/userPages/add_wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserServicesPage extends StatefulWidget {
  const UserServicesPage({Key? key}) : super(key: key);

  @override
  _UserServicesPageState createState() => _UserServicesPageState();
}

class _UserServicesPageState extends State<UserServicesPage> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('wallet')
            .where('uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data!.docs.isNotEmpty) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.yellow[800],
                  title: const Text('Add Services'),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.yellow[800],
                  onPressed: () {
                    Alert(
                        context: context,
                        title: 'service name',
                        closeIcon: const Icon(Icons.close),
                        content: Column(
                          children: [
                            TextFormField(
                              controller: name,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Service name'),
                            ),
                            TextFormField(
                              controller: price,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Service price'),
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                              child: const Text('Save'),
                              onPressed: () async {
                                if (name.text.isEmpty || price.text.isEmpty) {
                                  setState(() {
                                    Navigator.of(context).pop();
                                    showBar(
                                        context, 'please enter all field', 0);
                                  });
                                } else {
                                  try {
                                    String? username = user.displayName;
                                    var res = await FirebaseFirestore.instance
                                        .collection('Worker')
                                        .where('name', isEqualTo: username)
                                        .get();
                                    List<String> numbers = [];
                                    res.docs.forEach((element) {
                                      numbers.add(element['phone']);
                                    });
                                    String number = numbers[0];
                                    await FirebaseFirestore.instance
                                        .collection('services')
                                        .doc()
                                        .set({
                                      'uid': user.uid,
                                      'workernumber': number,
                                      'workername': username,
                                      'name': name.text,
                                      'price':
                                          int.tryParse(price.text.toString())
                                    });
                                    setState(() {
                                      price.clear();
                                      Navigator.of(context).pop();
                                      showBar(context, "Service Added", 1);
                                    });
                                  } catch (e) {
                                    setState(() {
                                      price.clear();
                                      Navigator.of(context).pop();

                                      showBar(context, 'somethings wrong', 0);
                                    });
                                  }
                                }
                              })
                        ]).show();
                  },
                  child: const Icon(Icons.add),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('services')
                          // .where('uid', isEqualTo: user.uid)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      return ExpansionTile(
                                        title: Text(
                                            '${snapshot.data!.docs[index]['name']}'),
                                        subtitle: Text(
                                            '${snapshot.data!.docs[0]['price']} SDG'),
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  Alert(
                                                    context: context,
                                                    desc:
                                                        'Are sure to delete this Service',
                                                    buttons: [
                                                      DialogButton(
                                                          child: const Text(
                                                              'Delete'),
                                                          onPressed: () async {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'services')
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .delete();
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                showBar(
                                                                    context,
                                                                    "Service deleted",
                                                                    1);
                                                              });
                                                            } catch (e) {
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                showBar(
                                                                    context,
                                                                    'somethings wrong',
                                                                    0);
                                                              });
                                                            }
                                                          })
                                                    ],
                                                  ).show();
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  Alert(
                                                    context: context,
                                                    content: TextFormField(
                                                      controller: price,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  'Enter New Service price'),
                                                    ),
                                                    buttons: [
                                                      DialogButton(
                                                          child: const Text(
                                                              'edit'),
                                                          onPressed: () async {
                                                            try {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'services')
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                                'price': int
                                                                    .tryParse(price
                                                                        .text
                                                                        .toString())
                                                              });
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                showBar(
                                                                    context,
                                                                    "Service update",
                                                                    1);
                                                              });
                                                            } catch (e) {
                                                              setState(() {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                showBar(
                                                                    context,
                                                                    'somethings wrong',
                                                                    0);
                                                              });
                                                            }
                                                          })
                                                    ],
                                                  ).show();
                                                },
                                                icon: const Icon(Icons.edit),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const Text(
                                          'No available services');
                                    }
                                  }
                                });
                          } else {
                            return Center(
                              child: Text('No Availble Services'),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              );
            } else {
              return Column(children: [
                const Text('You Dont have a wallet !!!'),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddWallet()));
                    },
                    child: const Text('make wallet'))
              ]);
            }
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

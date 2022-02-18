import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        title: const Text('Offers Page'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[800],
        onPressed: () {
          Alert(
              context: context,
              title: 'ADD Offer',
              closeIcon: const Icon(Icons.close),
              content: Column(
                children: [
                  TextFormField(
                    controller: name,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(hintText: 'Enter Offers amount'),
                  ),
                  TextFormField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(hintText: 'Enter Offers price'),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      if (name.text.isEmpty || price.text.isEmpty) {
                        setState(() {
                          showBar(context, 'please enter all field', 0);
                        });
                      } else {
                        try {
                          await FirebaseFirestore.instance
                              .collection('offers')
                              .doc()
                              .set({
                            'amount': int.tryParse(name.text.toString()),
                            'price': int.tryParse(price.text.toString())
                          });
                          setState(() {
                            Navigator.of(context).pop();
                            showBar(context, "Offers Added", 1);
                          });
                        } catch (e) {
                          setState(() {
                            showBar(context, 'somethings wrong', 0);
                          });
                        }
                      }
                    })
              ]).show();
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('offers').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTileCard(
                        title: Text(
                            'amount: ${snapshot.data!.docs[index]['amount']}'),
                        subtitle: Text(
                            'Price: ${snapshot.data!.docs[index]['price']} SDG'),
                      );
                    });
              } else {
                return const Center(
                  child: Text('No Available Offers'),
                );
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

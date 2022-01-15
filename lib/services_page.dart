import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  TextEditingController name = TextEditingController();
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );
  String url = '';
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Page'),
        backgroundColor: Colors.yellow[800],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow[800],
          child: const Center(child: Icon(Icons.add)),
          onPressed: () async {
            Alert(
                context: context,
                title: 'service name',
                closeIcon: const Icon(Icons.close),
                content: Column(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration:
                          const InputDecoration(hintText: 'Enter Service name'),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('images')
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        return GridView.builder(
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 16,
                                              childAspectRatio: .90,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    url = snapshot.data!
                                                        .docs[index]['image'];
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Container(
                                                  height: height / 6,
                                                  width: width / 6,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.contain,
                                                    imageUrl: snapshot.data!
                                                        .docs[index]['image'],
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Center(
                                                      child: CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            (const Icon(
                                                                Icons.error)),
                                                  ),
                                                ),
                                              );
                                            });
                                      }));
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow[700],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        width: data.size.width / 3.5,
                        height: data.size.height / 15,
                        padding: const EdgeInsets.all(
                          8,
                        ),
                        child: const Center(
                          child: Text(
                            "Add image",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (name.text.isEmpty) {
                          setState(() {
                            showBar(context, 'please enter name', 0);
                          });
                        } else {
                          if (url.isEmpty) {
                            setState(() {
                              showBar(context, 'please select image', 0);
                            });
                          } else {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('Services')
                                  .doc()
                                  .set({'name': name.text, 'image': url});
                              setState(() {
                                Navigator.of(context).pop();
                                showBar(context, "Service Added", 1);
                              });
                            } catch (e) {
                              setState(() {
                                showBar(context, 'somethings wrong', 0);
                              });
                            }
                          }
                        }
                      })
                ]).show();
          }),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Services').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpansionTileCard(
                        title: Text('${snapshot.data!.docs[index]['name']}'),
                        subtitle: const Text('tab to edit or delete'),
                        children: <Widget>[
                          const Divider(
                            thickness: 1.0,
                            height: 1.0,
                          ),
                          Row(
                            children: [
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceAround,
                                buttonHeight: 52.0,
                                buttonMinWidth: 90.0,
                                children: [
                                  TextButton(
                                      style: flatButtonStyle,
                                      onPressed: () async {
                                        Alert(
                                            context: context,
                                            title: 'Change service name',
                                            closeIcon: const Icon(Icons.close),
                                            content: TextFormField(
                                              controller: name,
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      'Enter new Service name'),
                                            ),
                                            buttons: [
                                              DialogButton(
                                                  child: const Text('Save'),
                                                  onPressed: () async {
                                                    if (name.text.isEmpty) {
                                                      setState(() {
                                                        showBar(
                                                            context,
                                                            'please enter name',
                                                            0);
                                                      });
                                                    } else {
                                                      try {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Services')
                                                            .doc(snapshot.data!
                                                                .docs[index].id)
                                                            .update({
                                                          'name': name.text
                                                        });
                                                        setState(() {
                                                          Navigator.of(context)
                                                              .pop();

                                                          showBar(
                                                              context,
                                                              "Service updated",
                                                              1);
                                                        });
                                                      } catch (e) {
                                                        setState(() {
                                                          Navigator.of(context)
                                                              .pop();
                                                          showBar(
                                                              context,
                                                              'somethings wrong',
                                                              0);
                                                        });
                                                      }
                                                    }
                                                  })
                                            ]).show();
                                      },
                                      child: Column(
                                        children: const <Widget>[
                                          Icon(Icons.share),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Text('Change Service Name'),
                                        ],
                                      )),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceAround,
                                    buttonHeight: 52.0,
                                    buttonMinWidth: 90.0,
                                    children: [
                                      TextButton(
                                          style: flatButtonStyle,
                                          onPressed: () async {
                                            setState(() {
                                              showLoadingDialog(context);
                                            });

                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('Services')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete();
                                              setState(() {
                                                Navigator.of(context).pop();
                                                showBar(context,
                                                    "Service deleted", 1);
                                              });
                                            } catch (e) {
                                              setState(() {
                                                Navigator.of(context).pop();
                                                showBar(context,
                                                    'somethings wrong', 0);
                                              });
                                            }
                                          },
                                          child: Column(
                                            children: const <Widget>[
                                              Icon(Icons.delete_forever,
                                                  color: Colors.red),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Text(
                                                'Delete Service',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ]);
                  });
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

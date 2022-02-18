import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WorkshopRequest extends StatefulWidget {
  const WorkshopRequest({Key? key}) : super(key: key);

  @override
  _WorkshopRequestState createState() => _WorkshopRequestState();
}

class _WorkshopRequestState extends State<WorkshopRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('workshop')
                  // .where('aprrov', isEqualTo: 0)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No A vailable requset',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    );
                  } else {
                    return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Admin(snapshot.data!.docs[index]);
                        },
                        itemCount: snapshot.data!.docs.length);
                  }
                }
              }),
        ));
  }

  Widget Admin(dynamic data) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        height: 200,
        width: 200,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Request by:  ${data['username']}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          Text(
            'Phone Number:  ${data['phone']}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 18),
            child: Text('workShop Name:  ${data['workshopName']}',
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, left: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Status: ',
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  data['status'] == 0
                      ? const Text('Rejected',
                          style: TextStyle(fontSize: 14, color: Colors.red))
                      : const Text('Accepted',
                          style: TextStyle(fontSize: 14, color: Colors.green))
                ],
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15, right: 15)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(19, 26, 44, 1.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              19, 26, 44, 1.0))))),
                      onPressed: () {
                        accept(data.id);
                      },
                      child: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15, right: 15)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(19, 26, 44, 1.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              19, 26, 44, 1.0))))),
                      onPressed: () {
                        reject(data.id);
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future accept(String id) async {
    setState(() {
      showLoadingDialog(context);
    });
    try {
      var res = await FirebaseFirestore.instance
          .collection('workshop')
          .doc(id)
          .update({
        "status": 1,
      });
      setState(() {
        Navigator.of(context).pop();
        showBar(context, 'Admin Accepted', 1);
      });
    } catch (e) {
      setState(() {
        Navigator.of(context).pop();
        showBar(context, e.toString(), 0);
      });
    }
  }

  Future reject(String id) async {
    setState(() {
      showLoadingDialog(context);
    });
    try {
      var res = await FirebaseFirestore.instance
          .collection('workshop')
          .doc(id)
          .update({
        "status": 0,
      });
      setState(() {
        Navigator.of(context).pop();
        showBar(context, 'Admin Rejected', 1);
      });
    } catch (e) {
      setState(() {
        Navigator.of(context).pop();
        showBar(context, e.toString(), 0);
      });
    }
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

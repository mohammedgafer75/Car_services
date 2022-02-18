import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class Profit extends StatefulWidget {
  const Profit({Key? key}) : super(key: key);

  @override
  _ProfitState createState() => _ProfitState();
}

class _ProfitState extends State<Profit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Page'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('adminwallet').snapshots(),
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
                int balance = 0;
                int all = 0;
                snapshot.data!.docs.forEach((element) {
                  int b = element['balance'];
                  all += b;
                  if (element['day'] == DateTime.now().day) {
                    int b = element['balance'];
                    balance += b;
                  }
                });
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Today Profit: $balance',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total Profit: $all',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable2(
                            headingRowColor: MaterialStateProperty.all(
                                const Color.fromRGBO(19, 26, 44, 1.0)),
                            headingTextStyle: TextStyle(color: Colors.white),
                            showBottomBorder: true,
                            columns: const [
                              DataColumn2(label: Text('Month')),
                              DataColumn2(label: Text('day')),
                              DataColumn2(label: Text('profit')),
                            ],
                            rows: List<DataRow>.generate(
                                snapshot.data!.docs.length,
                                (index) => DataRow(cells: [
                                      DataCell(Text(
                                          '${snapshot.data!.docs[index]['month']}')),
                                      DataCell(Text(
                                          '${snapshot.data!.docs[index]['day']}')),
                                      DataCell(Text(
                                          '${snapshot.data!.docs[index]['balance']}')),
                                      // DataCell(Text('$balance'))
                                    ]))),
                      ),
                    ],
                  ),
                );
              }
            }
          }),
    );
  }
}

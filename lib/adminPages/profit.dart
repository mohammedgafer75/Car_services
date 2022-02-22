import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class Profit extends StatefulWidget {
  const Profit({Key? key}) : super(key: key);

  @override
  _ProfitState createState() => _ProfitState();
}

class _ProfitState extends State<Profit> {
  num day = DateTime.now().day;
  num month = DateTime.now().month;
  num year = DateTime.now().year;
  TextEditingController Year = TextEditingController();
  List<num> category = List.generate(31, (index) => index + 1);
  List<num> monthlist = List.generate(12, (index) => index + 1);
  num currentCategorySelected = 1;
  num Month = 0;
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Page'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                  child: Text(
                "day :",
                style: TextStyle(color: Colors.black),
              )),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton(
                    icon: const Icon(Icons.timer, color: Colors.black),
                    iconEnabledColor: Colors.white,
                    items: category.map((dropDownStringItem) {
                      return DropdownMenuItem<num>(
                        value: dropDownStringItem,
                        child: Text('$dropDownStringItem'),
                      );
                    }).toList(),
                    onChanged: (num? newValueSelected) {
                      setState(() {
                        day = newValueSelected!;
                      });
                    },
                    value: day,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(
                  child: Text(
                "month :",
                style: TextStyle(color: Colors.black),
              )),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButton(
                    icon: const Icon(Icons.timer, color: Colors.black),
                    iconEnabledColor: Colors.white,
                    items: monthlist.map((num dropDownStringItem) {
                      return DropdownMenuItem<num>(
                        value: dropDownStringItem,
                        child: Text('$dropDownStringItem'),
                      );
                    }).toList(),
                    onChanged: (num? newValueSelected) {
                      setState(() {
                        month = newValueSelected!;
                      });
                    },
                    value: month,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              padding: EdgeInsets.only(right: width / 8, left: width / 8),
              height: height * 0.1,
              width: width * 1.0,

              // decoration: BoxDecoration(
              //   color: Colors.grey[500].withOpacity(0.5),
              //   borderRadius: BorderRadius.circular(16),
              // ),
              child: TextFormField(
                controller: Year,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 3.0),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  prefixIcon: const Icon(
                    Icons.timer,
                    size: 28,
                    color: Colors.black,
                  ),

                  labelText: 'Year',

                  labelStyle: const TextStyle(color: Colors.black),
                  // hintText: hint,
                  hintStyle: const TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),

                //  style: kBodyText,
              ),
            ),
          ),
          Center(
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.only(
                      top: height / 45,
                      bottom: height / 45,
                      left: width / 10,
                      right: width / 10)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(19, 26, 44, 1.0)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: const BorderSide(
                              color: Color.fromRGBO(19, 26, 44, 1.0))))),
              onPressed: () async {
                if (Year.text.toString().isNotEmpty) {
                  setState(() {
                    year = int.tryParse(Year.text.toString())!;
                  });
                } else {
                  setState(() {});
                }
              },
              child: Text(
                "Search",
                style: TextStyle(fontSize: 20.0, color: Colors.yellow[800]),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('adminwallet')
                    .where('day', isEqualTo: day)
                    .where('month', isEqualTo: month)
                    .where('year', isEqualTo: year)
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
                        child: ListView(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Today Profit: $balance',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Total Profit: $all',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DataTable2(
                                  headingRowColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(19, 26, 44, 1.0)),
                                  headingTextStyle:
                                      TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}

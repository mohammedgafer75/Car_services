import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllProgress extends StatefulWidget {
  const AllProgress({Key? key}) : super(key: key);

  @override
  State<AllProgress> createState() => _AllProgress();
}

class _AllProgress extends State<AllProgress> {
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
        backgroundColor: Colors.yellow[800],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                    child: Text(
                  "Day :",
                  style: TextStyle(
                    color: Colors.black,
                  ),
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                    child: Text(
                  "Month :",
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
                    .collection('Progress')
                    .where('time', isEqualTo: day)
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                  'Total Progress: ${snapshot.data!.docs.length}'),
                            ),
                          ),
                          const Divider(),
                          Expanded(
                            flex: 2,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      width: width,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: SizedBox(
                                          height: 180,
                                          width: 70,
                                          child: ListView(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  '${snapshot.data!.docs[index]['type']} Services ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    ' Status: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  snapshot.data!.docs[index]
                                                              ['status'] ==
                                                          1
                                                      ? const Text(
                                                          ' Done ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      : snapshot.data!.docs[
                                                                      index]
                                                                  ['status'] ==
                                                              0
                                                          ? const Text(
                                                              ' Waiting ',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            )
                                                          : const Text(
                                                              ' Cancled ',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18, left: 18),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    ' User: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    ' ${snapshot.data!.docs[index]['name']} ',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18, left: 18),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    ' Maintenance worker: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    ' ${snapshot.data!.docs[index]['worker']} ',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18, left: 18),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    ' Time: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                      '${snapshot.data!.docs[index]['time']}/${snapshot.data!.docs[index]['month']}/${snapshot.data!.docs[index]['year']}',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black)),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Expanded(child: Icon(Icons.subdirectory_arrow_right))
                        ],
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

import 'package:car_services/adminPages/offers_page.dart';
import 'package:car_services/adminPages/services_dashboard.dart';
import 'package:car_services/adminPages/services_page.dart';
import 'package:car_services/adminPages/all_progress.dart';
import 'package:car_services/adminPages/workshop_request.dart';
import 'package:flutter/material.dart';
import 'package:car_services/adminPages/request_page.dart';
import 'package:car_services/change_password.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: height / 7,
        ),
        padding: EdgeInsets.only(left: width / 8, right: width / 8),
        child: Center(
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: [
                Card_d(
                  icon: const Icon(Icons.accessibility,
                      size: 30, color: Colors.white),
                  title: 'User Requset',
                  nav: RequestPage(table: 'Worker'),
                ),
                const Card_d(
                  icon:
                      Icon(Icons.accessibility, size: 30, color: Colors.white),
                  title: 'WorkShop Requset',
                  nav: WorkshopRequest(),
                ),
                Card_d(
                  icon: const Icon(Icons.accessibility,
                      size: 30, color: Colors.white),
                  title: 'Admin Requset',
                  nav: RequestPage(table: 'Admin'),
                ),
                const Card_d(
                  icon: Icon(Icons.supervised_user_circle_sharp,
                      size: 30, color: Colors.white),
                  title: 'Services',
                  nav: ServicesPage(),
                ),
                const Card_d(
                  icon: Icon(Icons.report, size: 30, color: Colors.white),
                  title: 'Reports',
                  nav: ServicesDashboard(),
                ),
                const Card_d(
                  icon: Icon(Icons.local_offer, size: 30, color: Colors.white),
                  title: 'Offers Page',
                  nav: OffersPage(),
                ),
                const Card_d(
                  icon: Icon(Icons.change_circle_outlined,
                      size: 30, color: Colors.white),
                  title: 'Change Password',
                  nav: ChangePassword(),
                ),
              ]),
        ),
      ),
    );
  }
}

class Card_d extends StatefulWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final dynamic icon;
  final dynamic nav;

  @override
  State<Card_d> createState() => _Card_dState();
}

// ignore: camel_case_types
class _Card_dState extends State<Card_d> {
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget.nav));
      },
      child: Card(
        color: const Color.fromRGBO(19, 26, 44, 1.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: widget.icon),
              const SizedBox(
                height: 10,
              ),
              Text(widget.title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

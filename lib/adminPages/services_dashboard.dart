import 'package:car_services/adminPages/admin_home_page.dart';
import 'package:car_services/adminPages/all_progress.dart';
import 'package:car_services/adminPages/profit.dart';
import 'package:car_services/adminPages/today_progress.dart';
import 'package:car_services/adminPages/workers.dart';
import 'package:flutter/material.dart';

class ServicesDashboard extends StatefulWidget {
  const ServicesDashboard({Key? key}) : super(key: key);

  @override
  _ServicesDashboardState createState() => _ServicesDashboardState();
}

class _ServicesDashboardState extends State<ServicesDashboard> {
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: height / 5,
        ),
        padding: EdgeInsets.only(
            top: height / 50, left: width / 8, right: width / 8),
        child: Center(
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: const [
                Card_d(
                  icon:
                      Icon(Icons.accessibility, size: 30, color: Colors.white),
                  title: 'Today processes',
                  nav: TodayProgress(),
                ),
                Card_d(
                  icon:
                      Icon(Icons.accessibility, size: 30, color: Colors.white),
                  title: 'All processes',
                  nav: AllProgress(),
                ),
                Card_d(
                  icon: Icon(Icons.change_circle_outlined,
                      size: 30, color: Colors.white),
                  title: 'Workers',
                  nav: Workers(),
                ),
                Card_d(
                  icon: Icon(Icons.money_sharp, size: 30, color: Colors.white),
                  title: 'Profit',
                  nav: Profit(),
                ),
              ]),
        ),
      ),
    );
  }
}

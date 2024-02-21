import 'package:charcoal_vendor/components/custom_drawer.dart';
import 'package:charcoal_vendor/screens/historypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/history_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    User? user = FirebaseAuth.instance.currentUser;
    return PopScope(
        canPop: false,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: const Color(0xFFE7ECEF),
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.list_outlined, color: Colors.white),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      DateTime? datePick = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2025));
                      if (datePick == null) return;
                      Get.to(HistoryPage(time: datePick, uid: user!.uid));
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                    ))
              ],
              bottom: const TabBar(
                  labelColor: Colors.white,
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 17,
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Color(0xFFFCA311),
                  tabs: <Widget>[
                    Tab(
                      child: Text('Pending'),
                    ),
                    Tab(
                      child: Text('Complete'),
                    ),
                  ]),
            ),
            body: TabBarView(
              children: [
                HistoryBody(
                  isOrder: true,
                  uid: user!.uid,
                ),
                HistoryBody(
                  isOrder: false,
                  uid: user.uid,
                ),
              ],
            ),
            drawer: const CustomDrawer(),
          ),
        ));
  }
}

import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/history_body.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int? currentTab;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFFE7ECEF),
          appBar: AppBar(
            leadingWidth: 110,
            centerTitle: true,
            leading: TextButton.icon(
              onPressed: () => Get.off(const HomePage()),
              icon: const Icon(
                Icons.chevron_left_outlined,
                size: 30,
                color: Colors.white,
              ),
              label: const Text(
                'Back',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
            title: const Text(
              'History',
              style: TextStyle(color: Colors.white),
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

                    // filterNavigate(
                    //     scaffoldKey, currentTab ?? 0, datePick, isDriver);
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
                uid: user!.uid,
              ),
            ],
          )),
    );
  }
}

import 'package:charcoal_vendor/screens/stockpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/customer_list.dart';
import '../screens/loginpage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF270E01),
      child: SafeArea(
          child: Stack(
        children: [
          ListView(
            children: <Widget>[
              buildHeader(context),
              buildBody(context),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Get.off(const LoginPage());
                },
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget buildHeader(context) {
    return CircleAvatar(
      radius: 100,
      backgroundColor: Colors.white,
      child: Image.asset(
        'assets/images/charcoal_transparent.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget buildBody(context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(children: <Card>[
        Card(
          child: ListTile(
            onTap: () => Get.to(const CustomerList()),
            title: const Text('New Order'),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              // color: Colors.white,
            ),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () => Get.to(const StockPage()),
            title: const Text('Stock'),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              // color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}

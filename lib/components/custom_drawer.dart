import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/loginpage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: const Color(0xFF270E01),
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
    return SizedBox(
      height: 260,
      child: Image.asset(
        'assets/images/charcoal_transparent.png',
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget buildBody(context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(children: <ListTile>[
        ListTile(
          onTap: () {},
          title: const Text('New Order'),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: Colors.white,
          ),
        ),
        ListTile(
          onTap: () {},
          title: const Text('Stock'),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: Colors.white,
          ),
        ),
      ]),
    );
  }
}

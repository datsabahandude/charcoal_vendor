import 'package:charcoal_vendor/screens/customer_list.dart';
import 'package:charcoal_vendor/screens/historypage.dart';
import 'package:charcoal_vendor/screens/loginpage.dart';
import 'package:charcoal_vendor/screens/stockpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    double height;
    if (currentOrientation == Orientation.portrait) {
      height = MediaQuery.of(context).size.width;
    } else {
      height = MediaQuery.of(context).size.height;
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.off(const LoginPage());
              },
              icon: const Icon(Icons.exit_to_app)),
          centerTitle: true,
          title: const Text(
            'Charcoal Vendor',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          // color: Colors.transparent,
          child: Wrap(
            spacing: 15,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Get.to(const CustomerList());
                },
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    constraints: BoxConstraints(minWidth: height * 0.2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE7ECEF),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: -const Offset(2, 2),
                            color: Colors.white,
                            inset: false,
                          ),
                          const BoxShadow(
                            blurRadius: 5,
                            offset: Offset(6, 6),
                            color: Colors.grey,
                            inset: false,
                          )
                        ]),
                    child: const Text(
                      'New Order',
                      textAlign: TextAlign.center,
                      // style: txtfont,
                    )),
              ),
              InkWell(
                onTap: () => Get.to(const StockPage()),
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    constraints: BoxConstraints(minWidth: height * 0.2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE7ECEF),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: -const Offset(2, 2),
                            color: Colors.white,
                            inset: false,
                          ),
                          const BoxShadow(
                            blurRadius: 5,
                            offset: Offset(6, 6),
                            color: Colors.grey,
                            inset: false,
                          )
                        ]),
                    child: const Text(
                      'Stock',
                      textAlign: TextAlign.center,
                      // style: txtfont,
                    )),
              ),
              InkWell(
                onTap: () => Get.to(const HistoryPage()),
                child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    constraints: BoxConstraints(minWidth: height * 0.2),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE7ECEF),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: -const Offset(2, 2),
                            color: Colors.white,
                            inset: false,
                          ),
                          const BoxShadow(
                            blurRadius: 5,
                            offset: Offset(6, 6),
                            color: Colors.grey,
                            inset: false,
                          )
                        ]),
                    child: const Text(
                      'History',
                      textAlign: TextAlign.center,
                      // style: txtfont,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

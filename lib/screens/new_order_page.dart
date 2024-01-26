import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/customappbar.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  String date = '';
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Get.off(const HomePage());
      },
      child: Scaffold(
          appBar: CustomAppBar(
              title: 'New Order', onPressed: () => Get.off(const HomePage())),
          body: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.black, spreadRadius: 1)
                      ]),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () async {
                            DateTime? datePick = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2025));
                            if (datePick == null) return;
                            setState(() {
                              date = DateFormat('d MMM yyyy').format(datePick);
                            });
                          },
                          icon: const Icon(
                            Icons.calendar_month_outlined,
                          )),
                      date.isNotEmpty
                          ? Text(
                              date,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

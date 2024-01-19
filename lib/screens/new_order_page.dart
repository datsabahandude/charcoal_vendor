import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/customappbar.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
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
        ));
  }
}

import 'package:charcoal_vendor/components/customappbar.dart';
import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'History',
        onPressed: () {
          // Get.off(const HomePage());
          Get.back();
        },
      ),
    );
  }
}

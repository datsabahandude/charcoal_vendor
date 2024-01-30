import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/customappbar.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  String date = DateFormat('d MMM yyyy HH:mm').format(DateTime.now());
  int? stock;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore fire = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    // fetch amount from db
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Stock', onPressed: () => Get.off(const HomePage())),
      body: Center(
        child: Column(children: <Widget>[]),
      ),
    );
  }
}

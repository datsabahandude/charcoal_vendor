import 'dart:async';

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
  TextEditingController stockctrl = TextEditingController();
  String date = DateFormat('d MMM yyyy HH:mm').format(DateTime.now());
  int? stock;
  int updatedstock = 0;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore fire = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot>? _listenStock;
  @override
  void initState() {
    super.initState();
    // fetch amount from db
    fetchStock();
  }

  @override
  void dispose() {
    _listenStock?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtfield = TextField(
      controller: stockctrl,
      keyboardType: TextInputType.number,
      onChanged: (val) {
        setState(() {
          stockctrl.text = val;
        });
      },
      decoration: InputDecoration(
          constraints: const BoxConstraints(maxWidth: 200),
          errorStyle: const TextStyle(
            color: Color(0xFFFF1C0C),
            fontWeight: FontWeight.w500,
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: "Restock..", // Indicator or label
          hintStyle: const TextStyle(
            fontSize: 12.0,
            color: Colors.black,
          ),
          prefixIcon: const Icon(Icons.edit),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: 'Stock', onPressed: () => Get.back()),
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 25, 15, 25),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black, spreadRadius: 1)
                  ]),
              child: Text('Stock: $stock'),
            ),
            const SizedBox(height: 25),
            txtfield,
          ],
        ),
      ),
      floatingActionButton: stockctrl.text.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () async {
                updateDB();
              },
              backgroundColor: const Color(0xFF270E01),
              label: const Text(
                'Add Stock',
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
          : Container(),
    );
  }

  Future<void> fetchStock() async {
    DocumentReference docRef = fire.collection('Users').doc(user!.uid);
    _listenStock = docRef.snapshots().listen((DocumentSnapshot event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        setState(() {
          stock = data['stock'] ?? 0;
        });
        _listenStock?.cancel();
      }
    });
  }

  Future<void> updateDB() async {
    updatedstock = stock! + int.parse(stockctrl.text);
    try {
      await fire
          .collection('Users')
          .doc(user!.uid)
          .set({'stock': updatedstock}).then((value) => processDone());
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.white);
    }
  }

  void processDone() {
    Get.snackbar('Success', 'Stock Updated', backgroundColor: Colors.white);
    Navigator.pop(context);
  }
}

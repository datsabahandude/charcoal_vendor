import 'package:charcoal_vendor/components/customappbar.dart';
import 'package:charcoal_vendor/models/order_model.dart';
import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/history_card.dart';

class HistoryPage extends StatefulWidget {
  final DateTime time;
  final String uid;
  const HistoryPage({
    super.key,
    required this.time,
    required this.uid,
  });

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Stream<QuerySnapshot>? _historyStream;
  List<Object> _historyList = [];
  bool isDriver = false;
  String err = '';
  double totalEarning = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('d MMM yyyy').format(widget.time);
    return PopScope(
        canPop: false,
        onPopInvoked: (val) async {
          if (val) {
            return;
          }
          Get.off(const HomePage());
        },
        child: Scaffold(
          appBar: CustomAppBar(
              title: date, onPressed: () => Get.off(const HomePage())),
          body: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _historyStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xFF14213D))),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Snapshot Error!',
                          ),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        if (err.isNotEmpty) {
                          return Center(
                              child: Text(
                            err,
                            style: const TextStyle(fontSize: 26),
                          ));
                        } else {
                          return const Center(
                            child: Text(
                              'No Trip History',
                              style: TextStyle(fontSize: 26),
                            ),
                          );
                        }
                      } else {
                        _historyList = snapshot.data!.docs
                            .map((doc) => OrderList.fromSnapshot(doc))
                            .toList();

                        return Container(
                          constraints: const BoxConstraints(
                              minWidth: 400, maxWidth: 400),
                          child: ListView.builder(
                            itemCount: _historyList.length,
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (context, index) {
                              final item = _historyList[index];
                              item as OrderList;
                              // totalEarning += item.price ?? 0;
                              return HistoryCard(
                                card: item,
                                type: false,
                                uid: widget.uid,
                                stock: 0,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                )
              ]),
            ),
          ),
        ));
  }

  Future<void> init() async {
    int month = widget.time.month;
    int year = widget.time.year;
    _historyStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .collection('Orders')
        .where('time',
            isGreaterThanOrEqualTo:
                DateTime(year, month, 1).millisecondsSinceEpoch)
        .where('time',
            isLessThan: DateTime(year, month + 1, 1).millisecondsSinceEpoch)
        .orderBy('time', descending: true)
        .snapshots();
  }
}

import 'package:charcoal_vendor/components/history_card.dart';
import 'package:charcoal_vendor/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryBody extends StatefulWidget {
  final bool isOrder;
  final String uid;
  const HistoryBody({
    super.key,
    required this.isOrder,
    required this.uid,
  });

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  Stream<QuerySnapshot>? _historyStream;
  List<Object> _historyList = [];
  bool isLimitReached = false;
  String err = '';
  int? stock;
  var statuscolor = const Color(0xFF138808);
  @override
  void initState() {
    super.initState();
    getStock();
    getHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: <Widget>[
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
                            'No Order',
                            style: TextStyle(fontSize: 26),
                          ),
                        );
                      }
                    } else {
                      // _isLoading = false;
                      _historyList = snapshot.data!.docs
                          .map((doc) => OrderList.fromSnapshot(doc))
                          .toList();

                      return Container(
                        constraints:
                            const BoxConstraints(minWidth: 400, maxWidth: 400),
                        child: ListView.builder(
                          itemCount: isLimitReached
                              ? _historyList.length + 1
                              : _historyList.length > 10
                                  ? 10
                                  : _historyList.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            if (index == 10) {
                              return const Text(
                                'Limit reached',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              );
                            }
                            final item = _historyList[index];
                            item as OrderList;

                            return HistoryCard(
                              card: item,
                              type: widget.isOrder,
                              uid: widget.uid,
                              stock: stock!,
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  Future<void> getHistory() async {
    if (widget.isOrder) {
      _historyStream = FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.uid)
          .collection('Orders')
          .where('status', isEqualTo: 'Pending')
          // .orderBy('time', descending: true)
          .limit(10)
          .snapshots();
    } else {
      _historyStream = FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.uid)
          .collection('Orders')
          .where('status', isEqualTo: 'Done')
          // .orderBy('time', descending: true)
          .limit(10)
          .snapshots();
    }
  }

  Future<void> getStock() async {
    final prefs = await SharedPreferences.getInstance();
    stock = prefs.getInt('stock') ?? 0;
  }
}

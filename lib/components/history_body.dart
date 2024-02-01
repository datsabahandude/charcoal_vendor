import 'package:charcoal_vendor/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:intl/intl.dart';

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
  var statuscolor = const Color(0xFF138808);
  @override
  void initState() {
    super.initState();
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
                            'Empty...',
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
                            int qty = int.parse('${item.qty}');
                            double total = qty * double.parse('${item.price}');
                            String date = DateFormat('d MMM yyyy HH:mm')
                                .format(DateTime.now());
                            statuscolor = widget.isOrder
                                ? const Color(0xFFFCA311)
                                : const Color(0xFF138808);
                            return Container(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFE7ECEF),
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                      child: AspectRatio(
                                        aspectRatio: 3 / 1,
                                        child: Row(
                                          children: <Widget>[
                                            AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: item.img != null
                                                    ? Image.network(
                                                        '${item.img}',
                                                        errorBuilder: (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) =>
                                                            Image.asset(
                                                          'assets/images/charcoal_transparent.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : Image.asset(
                                                        'assets/images/charcoal_transparent.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            AspectRatio(
                                              aspectRatio: 5 / 3,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          '${item.customer}',
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xFF270E01),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${item.status}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  statuscolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${item.location}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                  Text(
                                                    date,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF138808),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                  RichText(
                                                      text: TextSpan(
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .black),
                                                          children: <InlineSpan>[
                                                        TextSpan(
                                                            text: '$qty ',
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                color: Color(
                                                                    0xFF138808))),
                                                        TextSpan(
                                                            text:
                                                                'x RM${item.price} ='),
                                                        TextSpan(
                                                            text: ' RM$total',
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xFF138808))),
                                                      ])),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))),
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
}

import 'package:charcoal_vendor/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryCard extends StatelessWidget {
  final OrderList card;
  final int stock;
  final bool type;
  final String uid;
  const HistoryCard({
    super.key,
    required this.card,
    required this.stock,
    required this.type,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    int qty = int.parse('${card.qty}');
    double total = qty * double.parse('${card.price}');
    String date = DateFormat('d MMM yyyy HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse('${card.time}')));
    var statuscolor = card.status == 'Pending'
        ? const Color(0xFFFCA311)
        : const Color(0xFF138808);
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFE7ECEF),
                  borderRadius: BorderRadius.circular(15),
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
                        borderRadius: BorderRadius.circular(10),
                        child: card.img != null
                            ? Image.network(
                                '${card.img}',
                                errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) =>
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
                    InkWell(
                      onTap: () {
                        if (type) popup(card.oid!, context, qty);
                      },
                      child: AspectRatio(
                        aspectRatio: 5 / 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${card.customer}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF270E01),
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${card.status}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: statuscolor,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${card.location}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              date,
                              style: const TextStyle(
                                  color: Color(0xFF138808),
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                    children: <InlineSpan>[
                                  TextSpan(
                                      text: '$qty ',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF138808))),
                                  TextSpan(text: 'x RM${card.price} ='),
                                  TextSpan(
                                      text: ' RM$total',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF138808))),
                                ])),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  void popup(String oid, BuildContext context, qty) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    onTap: () => updateItem(true, oid, 0),
                    title: const Text(
                      'Mark Complete',
                      style: TextStyle(color: Color(0xFF138808)),
                    ),
                    trailing: const Icon(Icons.done, color: Color(0xFF138808)),
                  ),
                  ListTile(
                    onTap: () => updateItem(false, oid, qty),
                    title: const Text(
                      'Cancel Order',
                      style: TextStyle(color: Color(0xFFB51423)),
                    ),
                    trailing: const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFB51423),
                    ),
                  ),
                ],
              ));
        }));
  }

  Future<void> updateItem(bool isDone, String oid, int qty) async {
    var docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Orders')
        .doc(oid);
    try {
      if (isDone) {
        await docRef.update({'status': 'Done'});
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .update({'stock': stock + qty}).then((value) => docRef.delete());
      }
      Get.back();
    } catch (e) {
      debugPrint('error');
    }
  }
}

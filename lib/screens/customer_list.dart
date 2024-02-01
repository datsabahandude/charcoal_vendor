import 'package:charcoal_vendor/components/customappbar.dart';
import 'package:charcoal_vendor/models/list_model.dart';
import 'package:charcoal_vendor/screens/add_customer_page.dart';
import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:charcoal_vendor/screens/new_order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:get/get.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  User? user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot>? _customerStream;
  List<Object> _customerList = [];
  FirebaseFirestore fire = FirebaseFirestore.instance;
  int remainingstock = 0;
  @override
  void initState() {
    super.initState();
    _customerStream = fire
        .collection('Users')
        .doc(user!.uid)
        .collection('Customers')
        .snapshots();
    // need to add listener for remaining stock
    fetchStock();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (didpop) {
          return;
        }
        Get.off(const HomePage());
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'Select Customer',
            onPressed: () => Get.off(const HomePage())),
        body: Center(
          child: Container(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                    stream: _customerStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xFF270E01))),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Snapshot Error!',
                              style: TextStyle(color: Color(0xFF270E01))),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Customer',
                            style: TextStyle(
                                fontSize: 26, color: Color(0xFF270E01)),
                          ),
                        );
                      } else {
                        _customerList = snapshot.data!.docs
                            .map((doc) => Customer.fromSnapshot(doc))
                            .toList();

                        return Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: ListView.builder(
                            itemCount: _customerList.length,
                            padding: const EdgeInsets.all(12),
                            itemBuilder: (context, index) {
                              final item = _customerList[index];
                              item as Customer;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                  child: ListTile(
                                    onTap: () => Get.to(NewOrderPage(
                                      item: item,
                                      stocks: remainingstock,
                                    )),
                                    leading: CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage('${item.img}'),
                                    ),
                                    title: Text(
                                      item.customer!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(item.location!),
                                    trailing: InkWell(
                                      onTap: () {
                                        popup(
                                            item.img, item.customer, item.cid);
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Color(0xFFB51423),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ))
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(const AddCustomerPage()),
          backgroundColor: const Color(0xFF270E01),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> fetchStock() async {
    DocumentReference docRef = fire.collection('Users').doc(user!.uid);
    await docRef.get().then((value) {
      setState(() {
        remainingstock = value['stock'] ?? 0;
      });
    });
  }

  void popup(image, customer, id) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            content: Text('Remove $customer ?',
                style: const TextStyle(color: Color(0xFFB51423), fontSize: 18)),
            actions: [
              TextButton(
                  onPressed: () {
                    remove(id, image);
                  },
                  child: const Text('Confirm'))
            ],
          );
        }));
  }

  void remove(String id, String img) {
    try {
      FirebaseStorage.instance.refFromURL(img).delete().then((value) => fire
          .collection('Users')
          .doc(user!.uid)
          .collection('Customers')
          .doc(id)
          .delete());
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar('Error', 'Unable to delete');
    }
  }
}

import 'package:charcoal_vendor/components/customappbar.dart';
import 'package:charcoal_vendor/models/list_model.dart';
import 'package:charcoal_vendor/screens/add_customer_page.dart';
import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    _customerStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection('Customers')
        .snapshots();
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
                        // _isLoading = false;
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
                              return null;
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
}

import 'package:charcoal_vendor/components/customappbar.dart';
import 'package:charcoal_vendor/screens/add_customer_page.dart';
import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
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
        body: Container(),
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

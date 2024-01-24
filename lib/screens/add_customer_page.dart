import 'package:charcoal_vendor/components/customappbar.dart';
import 'package:charcoal_vendor/screens/customer_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Get.off(const CustomerList());
      },
      child: Scaffold(
        appBar: CustomAppBar(
            title: 'Add Customer',
            onPressed: () => Get.off(const CustomerList())),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 120,
                    backgroundColor: Color(0xFF270E01),
                    child: CircleAvatar(
                      radius: 118,
                      backgroundImage:
                          AssetImage('assets/images/charcoal_transparent.png'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white),
                        child: const Icon(Icons.add_a_photo_outlined)),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: <Widget>[
                  Text('hello'),
                  Text('how r u'),
                ]),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black, spreadRadius: 1)
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

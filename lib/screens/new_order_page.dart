import 'package:charcoal_vendor/screens/customer_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/customappbar.dart';
import '../models/list_model.dart';

class NewOrderPage extends StatefulWidget {
  final Customer item;
  const NewOrderPage({super.key, required this.item});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  DateTime datetime = DateTime.now();
  String date = DateFormat('d MMM yyyy HH:mm').format(DateTime.now());
  // double iprice = 3;
  // int qty = 1;
  // double total = 0;
  @override
  void initState() {
    super.initState();
    qtyController.text = '1';
    priceController.text = '3';
    // calc();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Get.off(const CustomerList());
      },
      child: Scaffold(
          appBar: CustomAppBar(
              title: 'New Order',
              onPressed: () => Get.off(const CustomerList())),
          body: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(color: Colors.black, spreadRadius: 1)
                      ]),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => setDate(context),
                          icon: const Icon(
                            Icons.calendar_month_outlined,
                          )),
                      date.isNotEmpty
                          ? Text(
                              date,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                DataTable(columns: const <DataColumn>[
                  DataColumn(label: Text('Quantity'), numeric: true),
                  // DataColumn(label: Text('')),
                  DataColumn(label: Text('Price'), numeric: true),
                  // DataColumn(label: Text('')),
                  DataColumn(label: Text('Total'), numeric: true),
                ], rows: <DataRow>[
                  DataRow(cells: [
                    DataCell(
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Text(qtyController.text),
                          onTap: () {
                            _editCell('Quantity', qtyController.text)
                                .then((newValue) {
                              if (newValue != null) {
                                setState(() {
                                  qtyController.text = newValue;
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    // const DataCell(Text('x')),
                    DataCell(
                      GestureDetector(
                        child: Text('RM ${priceController.text}'),
                        onTap: () {
                          _editCell('Price', priceController.text)
                              .then((newValue) {
                            if (newValue != null) {
                              setState(() {
                                priceController.text = newValue;
                              });
                            }
                          });
                        },
                      ),
                    ),
                    // const DataCell(Text('=')),
                    DataCell(
                      Text('RM ${calculateTotal()}'),
                    ),
                  ]),
                ]),
              ],
            ),
          )),
    );
  }

  Future<void> setDate(context) async {
    DateTime? datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));
    if (datePick == null) return;
    TimeOfDay? newtime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newtime == null) return;
    datetime = DateTime(
      datePick.year,
      datePick.month,
      datePick.day,
      newtime.hour,
      newtime.minute,
    );
    setState(() {
      date = DateFormat('d MMM yyyy HH:mm').format(datetime);
    });
  }

  Future _editCell(String title, String currentValue) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: TextEditingController(text: currentValue),
            onChanged: (value) {
              currentValue = value;
            },
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, currentValue);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String calculateTotal() {
    double total =
        double.parse(qtyController.text) * double.parse(priceController.text);
    return total.toString();
  }

  // void calc() {
  //   total =
  //       double.parse(qtyController.text) * double.parse(priceController.text);
  // }
}

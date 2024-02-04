import 'package:charcoal_vendor/screens/customer_list.dart';
import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/customappbar.dart';
import '../models/list_model.dart';

class NewOrderPage extends StatefulWidget {
  final Customer item;
  final int stocks;
  const NewOrderPage({super.key, required this.item, required this.stocks});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage>
    with SingleTickerProviderStateMixin {
  _NewOrderPageState() {
    _selectedVal = status[0];
  }
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime datetime = DateTime.now();
  String date = DateFormat('d MMM yyyy HH:mm').format(DateTime.now());
  final status = ['Pending', 'Done'];
  String? _selectedVal = '';
  int? stock;
  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore fire = FirebaseFirestore.instance;
  late SharedPreferences _pref;
  @override
  void initState() {
    super.initState();
    init();
    qtyController.text = '0';
    priceController.text = '3.5';
    locationController.text = widget.item.location!;

    stock = widget.stocks;
  }

  @override
  Widget build(BuildContext context) {
    final locationField = TextField(
        maxLength: 15,
        autofocus: false,
        controller: locationController,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          locationController.text = value;
        },
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 180),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            errorStyle: const TextStyle(
              color: Color(0xFFFF1C0C),
              fontWeight: FontWeight.w500,
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: const Icon(Icons.location_on_outlined,
                color: Color(0xFF270E01)),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Location",
            hintStyle: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF270E01),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Get.off(const CustomerList());
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CustomAppBar(
              title: 'Order (${widget.item.customer})',
              onPressed: () => Get.off(const CustomerList())),
          body: Center(
            child: isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFF270E01)))
                : Column(
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
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
                                            decoration:
                                                TextDecoration.underline),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            DropdownButtonFormField(
                              value: _selectedVal,
                              items: status
                                  .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                            color: Color(0xFF270E01),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedVal = val as String;
                                });
                              },
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                constraints:
                                    const BoxConstraints(maxWidth: 180),
                                prefixIcon: _selectedVal == 'Pending'
                                    ? const Icon(
                                        Icons.pending_rounded,
                                      )
                                    : _selectedVal == 'Done'
                                        ? const Icon(
                                            Icons.done,
                                            color: Color(0xFF138808),
                                          )
                                        : const Icon(
                                            Icons.event_repeat_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              ),
                            ),
                            const SizedBox(height: 15),
                            locationField,
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      DataTable(
                        headingTextStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                        columns: <DataColumn>[
                          DataColumn(
                              label: Text(
                                  'Quantity (${stock! - int.parse(qtyController.text)})')),
                          const DataColumn(label: Text('Price')),
                          const DataColumn(label: Text('Total')),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: [
                              DataCell(
                                showEditIcon: true,
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
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(qtyController.text),
                                ),
                              ),
                              DataCell(
                                showEditIcon: true,
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
                                Text('RM ${priceController.text}'),
                              ),
                              DataCell(
                                Text('RM ${calculateTotal()}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          onPressed: () {
                            if (qtyController.text == '0') {
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            postDetailsToFireStore();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: const Text(
                            "Add Order",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF270E01),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
          )),
    );
  }

  Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
    priceController.text = _pref.getString('${widget.item.cid}') ?? '3.5';
    setState(() {});
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
            inputFormatters: <TextInputFormatter>[
              // allow only number formats
              title == 'Price'
                  ? FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                  : FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
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
                if (currentValue.isEmpty) {
                  currentValue = '0';
                }
                if (title == 'Price') {
                  _pref.setString('${widget.item.cid}', currentValue);
                }
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

  Future postDetailsToFireStore() async {
    var oid = DateTime.now().toString();
    int sendtime = datetime.millisecondsSinceEpoch;

    try {
      await fire
          .collection('Users')
          .doc(user!.uid)
          .collection('Orders')
          .doc(oid)
          .set({
        'cid': widget.item.cid,
        'img': widget.item.img,
        'oid': oid,
        'time': sendtime,
        'status': _selectedVal,
        'name': widget.item.customer,
        'location': locationController.text,
        'qty': qtyController.text,
        'price': priceController.text,
      }).then((value) => updateStock(qtyController.text));
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong',
          backgroundColor: Colors.white);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateStock(String qty) async {
    int newstock = stock! - int.parse(qty);
    await _pref.setInt('stock', newstock);
    DocumentReference docRef = fire.collection('Users').doc(user!.uid);
    try {
      await docRef.update({'stock': newstock}).then((value) => processDone());
    } catch (e) {
      Get.snackbar('Error', 'Error updating stock',
          backgroundColor: Colors.white);
      setState(() {
        isLoading = false;
      });
    }
  }

  void processDone() {
    Get.snackbar('Success', 'Order Added', backgroundColor: Colors.white);
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
    setState(() => isLoading = false);
  }
}

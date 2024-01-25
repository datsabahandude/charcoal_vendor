import 'dart:io';

import 'package:charcoal_vendor/components/customappbar.dart';
import 'package:charcoal_vendor/screens/customer_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final nameEditingController = TextEditingController();
  final locationEditingController = TextEditingController();
  File? image;
  Uint8List? imageBytes;
  UploadTask? uploadTask;
  String? url;
  String date = '';

  /// Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    nameEditingController.dispose();
    locationEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
        maxLength: 15,
        autofocus: false,
        controller: nameEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Customer Name ?';
          }
          return null;
        },
        onSaved: (value) {
          nameEditingController.text = value!;
        },
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 300),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            errorStyle: const TextStyle(
              color: Color(0xFFFF1C0C),
              fontWeight: FontWeight.w500,
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon:
                const Icon(Icons.paste_outlined, color: Color(0xFF270E01)),
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Customer",
            hintStyle: const TextStyle(
              fontSize: 16.0,
              color: Color(0xFF270E01),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));
    final locationField = TextFormField(
        maxLength: 15,
        autofocus: false,
        controller: locationEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Location ?';
          }
          return null;
        },
        onSaved: (value) {
          locationEditingController.text = value!;
        },
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 300),
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
                  CircleAvatar(
                    radius: 102,
                    backgroundColor: const Color(0xFF270E01),
                    child: imageBytes != null
                        ? ClipOval(
                            child: Image.memory(
                              imageBytes!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(
                                'assets/images/charcoal_transparent.png'),
                            backgroundColor: Colors.white,
                          ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: ElevatedButton(
                        onPressed: () => popup(),
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
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.white,
              //       boxShadow: const [
              //         BoxShadow(color: Colors.black, spreadRadius: 1)
              //       ]),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       IconButton(
              //           onPressed: () async {
              //             DateTime? datePick = await showDatePicker(
              //                 context: context,
              //                 initialDate: DateTime.now(),
              //                 firstDate: DateTime(2023),
              //                 lastDate: DateTime(2025));
              //             if (datePick == null) return;
              //             setState(() {
              //               date = DateFormat('d MMM yyyy').format(datePick);
              //             });
              //           },
              //           icon: const Icon(
              //             Icons.calendar_month_outlined,
              //           )),
              //       date.isNotEmpty
              //           ? Text(
              //               date,
              //               style: const TextStyle(
              //                   decoration: TextDecoration.underline),
              //             )
              //           : const SizedBox(),
              //     ],
              //   ),
              // ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 15.0,
                      ),
                      nameField,
                      locationField,
                      const SizedBox(
                        height: 10.0,
                      ),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        child: MaterialButton(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          onPressed: () async {
                            final isValid = _formKey.currentState!.validate();
                            if ((image == null) && isValid) {
                              setState(() {
                                isLoading = true;
                              });
                              if (url != null) {}
                              postDetailsToFireStore();
                            } else if (isValid) {
                              setState(() {
                                isLoading = true;
                              });
                              uploadImg();
                            } else if (!isValid) {
                              // Fluttertoast.showToast(
                              //     msg: "Empty Form !",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.CENTER,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.red,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                            } else {
                              // Fluttertoast.showToast(
                              //     msg: "Waduuh Error APAKA!!",
                              //     toastLength: Toast.LENGTH_SHORT,
                              //     gravity: ToastGravity.CENTER,
                              //     timeInSecForIosWeb: 1,
                              //     backgroundColor: Colors.red,
                              //     textColor: Colors.white,
                              //     fontSize: 16.0);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: const Text(
                            "Add Customer",
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
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void popup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Choose',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF270E01),
                  )),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    InkWell(
                      splashColor: const Color(0xFF270E01),
                      onTap: _pickImageCamera,
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera_alt,
                              color: Color(0xFF270E01),
                            ),
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF270E01),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      splashColor: const Color(0xFF270E01),
                      onTap: _pickImageGallery,
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.image_outlined,
                              color: Color(0xFF270E01),
                            ),
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF270E01),
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  Future _pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      Uint8List imageBytes = await image.readAsBytes();
      final imagetemp = File(image.path);
      setState(() {
        this.image = imagetemp;
        this.imageBytes = imageBytes;
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
      // Fluttertoast.showToast(
      //     msg: '$e',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
    // Navigator.pop(context);
  }

  Future _pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      Uint8List imageBytes = await image.readAsBytes();
      final imagetemp = File(image.path);
      setState(() {
        this.image = imagetemp;
        this.imageBytes = imageBytes;
      });
    } on PlatformException catch (e) {
      debugPrint('$e');
      // Fluttertoast.showToast(
      //     msg: '$e',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
    // Navigator.pop(context);
  }

  Future uploadImg() async {
    final path =
        '${user!.uid}/customers/${DateTime.now()}'; // considered UID for img
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      url = urlDownload;
    });
    postDetailsToFireStore();
  }

  Future postDetailsToFireStore() async {
    // var cid = DateTime.now().toString();
    // User? user = _auth.currentUser;
    // customerModel.customer = nameEditingController.text;
    // customerModel.uid = user!.uid;
    // customerModel.cid = cid;
    // customerModel.location = locationEditingController.text;
    // customerModel.img = url;

    // await firebaseFirestore
    //     .collection("Users")
    //     .doc(user.uid)
    //     .collection('Customers')
    //     .doc(cid) //empty = random generate
    //     .set(customerModel.toMap());
    // Fluttertoast.showToast(
    //   msg: "Added Successfully!\n (,,･`∀･)ﾉ",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.CENTER,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.green,
    //   textColor: Colors.white,
    //   fontSize: 16.0,
    // ).then((value) => processDone());
  }

  void processDone() {
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const CustomerList()),
        (route) => false);
    // setState(() => isLoading = false);
  }
}

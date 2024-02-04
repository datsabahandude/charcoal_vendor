import 'package:charcoal_vendor/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final emailEditingController = TextEditingController();
  final passEditingController = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Color(0xFF270E01)), // Input Text color
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your Email';
          } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid Email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 350),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            errorStyle: const TextStyle(
              color: Color(0xFFFF1C0C),
              fontWeight: FontWeight.w500,
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email", // Indicator or label
            hintStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));
    final passField = TextFormField(
        autofocus: false,
        controller: passEditingController,
        obscureText: true,
        style: const TextStyle(color: Color(0xFF270E01)),
        validator: (value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return 'Please Enter your Password';
          }
          if (!regex.hasMatch(value)) {
            return ("Wrong Password");
          }
          return null;
        },
        onSaved: (value) {
          passEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            constraints: const BoxConstraints(maxWidth: 350),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            errorStyle: const TextStyle(
              color: Color(0xFFFF1C0C),
              fontWeight: FontWeight.w500,
            ),
            fillColor: Colors.white,
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            // labelText: 'Password',
            hintStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.5)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )));

    /// Login
    final loginBtn = Material(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.all(14),
        color: const Color(0xFF270E01),
        minWidth: 300,
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            setState(() => isLoading = true);
            _login();
          }
        },
        child: const Text(
          "LOGIN",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xFF270E01))),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 100,
                            ),
                            const Center(
                                child: CircleAvatar(
                              backgroundColor: Color(0xFF270E01),
                              radius: 120,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                    'assets/images/charcoal_transparent.png'),
                                radius: 118,
                              ),
                            )),
                            const SizedBox(height: 15),
                            emailField,
                            const SizedBox(height: 25),
                            passField,
                            const SizedBox(height: 20),
                            loginBtn,
                          ],
                        )),
                  ),
                ),
        ));
  }

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailEditingController.text,
          password: passEditingController.text);
      _success();
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Incorrect Credentials',
          backgroundColor: Colors.white);
    }
  }

  void _success() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
}

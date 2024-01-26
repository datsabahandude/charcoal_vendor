import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  late String _email, _password;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
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
                            // _buildEmail(),
                            // const SizedBox(height: 5),
                            // _buildPassword(),
                            // const SizedBox(height: 10),
                            // _buildLogin(),
                          ],
                        )),
                  ),
                ),
        ));
  }
}

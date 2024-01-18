import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    double height;
    if (currentOrientation == Orientation.portrait) {
      height = MediaQuery.of(context).size.width;
    } else {
      height = MediaQuery.of(context).size.height;
    }
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.exit_to_app),
        centerTitle: true,
        title: const Text(
          'Charcoal Vendor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        // color: Colors.transparent,
        child: Wrap(
          spacing: 15,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                constraints: BoxConstraints(minWidth: height * 0.2),
                decoration: BoxDecoration(
                    color: const Color(0xFFE7ECEF),
                    borderRadius: BorderRadius.circular(30),
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
                child: const Text(
                  'New Order',
                  textAlign: TextAlign.center,
                  // style: txtfont,
                )),
            Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                constraints: BoxConstraints(minWidth: height * 0.2),
                decoration: BoxDecoration(
                    color: const Color(0xFFE7ECEF),
                    borderRadius: BorderRadius.circular(30),
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
                child: const Text(
                  'History',
                  textAlign: TextAlign.center,
                  // style: txtfont,
                )),
          ],
        ),
      ),
    );
  }
}

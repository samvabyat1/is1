// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Manage extends StatefulWidget {
  const Manage({super.key});

  @override
  State<Manage> createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  var wall = 0;
  var link;
  var frompsm;
  var isvisible = false;

  Future<void> gets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');

    DatabaseReference ref2 = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(email.toString().substring(0, email.toString().indexOf('@')));

    ref2.onValue.listen((event) {
      if (event.snapshot.child('wallet').exists) {
        if (mounted) {
          setState(() {
            wall = int.parse(event.snapshot.child('wallet').value.toString());
          });
        }
      }
    });
  }

  Future<Null> initUniLinks() async {
    try {
      Uri? initialLink = await getInitialUri();
      print(initialLink);
      link = initialLink.toString();

      if (initialLink.toString().contains('?')) {
        setState(() {
          isvisible = false;
        });
        frompsm = int.parse(initialLink
            .toString()
            .substring(initialLink.toString().indexOf('?') + 1));

        Fluttertoast.showToast(msg: '₹ $frompsm recieved as top up');

        final prefs = await SharedPreferences.getInstance();
        final String? email = prefs.getString('email');

        DatabaseReference ref2 = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(
                email.toString().substring(0, email.toString().indexOf('@')));

        ref2.child('wallet').set(wall + frompsm);
      }
    } on PlatformException {
      print('platfrom exception unilink');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current balance',
            style: TextStyle(color: Colors.white54),
          ),
          Text(
            '$wall',
            style: TextStyle(
                fontSize: 100,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff00f59b),
                child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isvisible = true;
                      });

                      final Uri url = Uri.parse('psm://open.com?topup');
                      try {
                        await launchUrl(url);
                      } catch (e) {
                        Fluttertoast.showToast(msg: 'Target app not found');
                      }
                    },
                    tooltip: 'Add money to wallet',
                    color: Colors.black,
                    icon: Icon(Icons.arrow_downward_rounded)),
              ),
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff7014f2),
                child: IconButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                          msg: 'Money redeem is currently unavailable');
                    },
                    tooltip: 'Redeem money to PSM',
                    color: Colors.white,
                    icon: Icon(Icons.arrow_upward_rounded)),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Visibility(
            visible: false,
            child: TextButton(
                onPressed: () {
                  initUniLinks();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Recieve top-up'),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

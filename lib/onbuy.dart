// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:is1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBuy extends StatefulWidget {
  final String url;
  const OnBuy({super.key, required this.url});

  @override
  State<OnBuy> createState() => _OnBuyState();
}

class _OnBuyState extends State<OnBuy> {
  var name;
  var amt;
  var prc;
  var prcnt;
  var ckey;
  var wall;

  Future<void> getStatus() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('market');

    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    DatabaseReference ref2 = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(email.toString().substring(0, email.toString().indexOf('@')));

    final snapshot = await ref2.child('wallet').get();
    if (snapshot.exists) {
      if (mounted) {
        setState(() {
          wall = int.parse(snapshot.value.toString());
        });
      }
    }

    ref.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        if (mounted &&
            child.key != 'date' &&
            child.child('name').value.toString().toLowerCase() ==
                name.toString().toLowerCase()) {
          setState(() {
            ckey = child.key.toString();
            prc = child.child('price').value.toString();
            prcnt = int.parse(amt) ~/ int.parse(prc);
          });
        }
      }
    });
  }

  Future<void> setstatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');

    DatabaseReference ref2 = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(email.toString().substring(0, email.toString().indexOf('@')))
        .child(ckey);

    final snapshot = await ref2.get();
    if (snapshot.exists) {
      ref2.child('name').set(name);
      ref2.child('share').set(int.parse(prcnt.toString()) +
          int.parse(snapshot.child('share').value.toString()));
      ref2.child('buy').set(
          int.parse(amt) + int.parse(snapshot.child('buy').value.toString()));
    } else {
      ref2.child('name').set(name);
      ref2.child('share').set(prcnt);
      ref2.child('buy').set(amt);
    }
    FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(email.toString().substring(0, email.toString().indexOf('@')))
        .child('wallet')
        .set((wall - int.parse(amt)).toString());
  }

  @override
  void initState() {
    super.initState();
    name = widget.url
        .substring(widget.url.indexOf('?') + 1, widget.url.indexOf('+'))
        .replaceAll('_', ' ');

    amt = widget.url.substring(widget.url.indexOf('+') + 1);

    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Reciept',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Wallet balance: ₹$wall',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Column(
                    children: [
                      Text(
                        'Just one more step to buy',
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        name,
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '$prcnt %',
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            color: Colors.blueGrey,
                            height: 20,
                            width: 1,
                          ),
                          Text(
                            '₹ $amt',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        '**Now you have access to their shares, you can hold on or sell it ahead. By proceeding you agree to all the terms and conditions governed by the respective company and also to this app.',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () {
                          if (int.parse(amt) <= wall) {
                            setstatus();
                            Fluttertoast.showToast(
                                msg: 'Transaction successful');
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(msg: 'Not enough balance');
                          }
                        },
                        child: Text(
                          'CONFIRM',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

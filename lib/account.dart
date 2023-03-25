// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var companies = [
    {'name': '', 'share': '', 'buy': '', 'sell': '', 'pl': ''}
  ];

  var wall = 0;

  Future<void> gets() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('market');
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');

    DatabaseReference ref2 = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(email.toString().substring(0, email.toString().indexOf('@')));

    ref2.onValue.listen((event) async {
      if (event.snapshot.child('wallet').exists && mounted) {
        setState(() {
          wall = int.parse(event.snapshot.child('wallet').value.toString());
        });
      }
      for (final child in event.snapshot.children) {
        if (mounted && child.key.toString() != 'wallet') {
          final snapshot =
              await ref.child(child.key.toString()).child('price').get();
          var c = int.parse(snapshot.value.toString()) *
                  int.parse(child.child('share').value.toString()) -
              int.parse(child.child('buy').value.toString());
          if (mounted) {
            setState(() {
              companies.add({
                'name': child.child('name').value.toString(),
                'share': child.child('share').value.toString(),
                'buy': child.child('buy').value.toString(),
                'sell': (int.parse(child.child('buy').value.toString()) + c)
                    .toString(),
                'pl': c.toString(),
              });
            });
          }
        }
      }
    });
  }

  Future<void> sell(int i) async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');

    DatabaseReference ref2 = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(email.toString().substring(0, email.toString().indexOf('@')));

    final snapshot = await ref2.get();

    for (final child in snapshot.children) {
      if (child.child('name').value.toString() == companies[i]['name']) {
        ref2.child('wallet').set(
            (wall + int.parse(companies[i]['sell'].toString())).toString());
        ref2.child(child.key.toString()).remove();
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    gets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          flex: 2,
                          onPressed: (context) {
                            Fluttertoast.showToast(
                                msg:
                                    'Redeem account balance is currently not available');
                          },
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          icon: Icons.redeem_rounded,
                          label: 'Redeem',
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Wallet balance',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            Text(
                              '₹ $wall',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  itemCount: companies.length - 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            flex: 2,
                            onPressed: (context) {
                              sell(index + 1);
                              Fluttertoast.showToast(
                                  msg: 'Share sold successfully');
                              Navigator.pop(context);
                            },
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            icon: Icons.sell_rounded,
                            label: 'Sell',
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    companies[index + 1]['name'].toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${companies[index + 1]['share'].toString()}%',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    companies[index + 1]['pl'].toString(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: (companies[index + 1]['pl']
                                                    .toString()[0] ==
                                                '-')
                                            ? Colors.red
                                            : Colors.green),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Buy price: ₹${companies[index + 1]['buy'].toString()}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Sell price: ₹${companies[index + 1]['sell'].toString()}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.indigo,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Slide for options ▶▶',
                  style: TextStyle(fontSize: 10, color: Colors.white60),
                ),
                SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

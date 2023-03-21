// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is1/settings.dart';
import 'account.dart';
import 'marketplace.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> updateStocks() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('market');

    final snapshot = await ref.child('date').get();
    String lastdate = snapshot.value.toString();

    String currentdate = DateFormat('ddMMyyyy').format(DateTime.now());

    if (currentdate != lastdate) {
      final snapshot1 = await ref.get();

      for (final child in snapshot1.children) {
        if (child.key != 'date') {
          int price = int.parse(child.child('price').value.toString());

          int newprice = price + random(-5, 6);

          ref.child(child.key.toString()).child('price').set(newprice);
          ref.child(child.key.toString()).child('train').set(
              '${(child.child('train').value != null) ? child.child('train').value.toString() : ''} $newprice');
        }
      }
      ref.child('date').set(currentdate);
    }
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  @override
  void initState() {
    super.initState();
    updateStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("asset/home-pic2.jpg"),
          fit: BoxFit.cover,
        )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image(
                                    image: AssetImage("asset/is1-logo.png"),
                                    height: 40,
                                  ),
                                  IconButton(
                                    tooltip: 'Settings',
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Settings(),
                                        )),
                                    icon: Icon(
                                      Icons.settings_outlined,
                                      color: Color(0xff6247AA),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('EEEE')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.purple,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('d MMMM')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
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
                //MIDSCREEN

                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.home_rounded),
                              ),
                              IconButton(
                                tooltip: 'Marketplace',
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Marketplace(),
                                    )),
                                icon: Icon(Icons.business_rounded),
                              ),
                              IconButton(
                                tooltip: 'Account',
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Account(),)) ,
                                icon: Icon(Icons.person_outline),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

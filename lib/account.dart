// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xff46325d),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Image(
                      image: AssetImage('asset/undraw_Mindfulness_8fly.png')))
            ],
          ),
        ),
      ),
    );
  }
}
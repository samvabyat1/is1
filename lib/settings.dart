// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                    'Settings',
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

// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:is1/home.dart';
import 'package:is1/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Montserrat',
      primarySwatch: Colors.purple,
    ),
    home: Splash(),
  ));
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  dynamic dest = Login();

  Future<void> initiate() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email') != null) {
      dest = Home();
    }
  }

  @override
  void initState() {
    super.initState();
    initiate();
    Timer(
        const Duration(milliseconds: 3000),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => dest)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset('asset/is1-logo.png'),
        ),
      ),
    );
  }
}

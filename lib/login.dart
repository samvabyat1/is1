// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:is1/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/front-img.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black54,
                  ],
                )),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: LoginSubscreen1(),
                ),
              ),
            ],
          )),
    );
  }
}

//

class LoginSubscreen1 extends StatefulWidget {
  @override
  State<LoginSubscreen1> createState() => _LoginSubscreen1State();
}

class _LoginSubscreen1State extends State<LoginSubscreen1> {
  var stt = 1;
  @override
  Widget build(BuildContext context) {
    if (stt == 1) {
      return Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            'Welcome',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Don't have an account? Create one, hit the Sign In button.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    setState(() {
                      stt = 2;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () {
                    setState(() {
                      stt = 3;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 25,
          ),
        ],
      );
    } else if (stt == 2) {
      return LoginSubscreen2();
    } else {
      return LoginSubscreen3();
    }
  }
}

//LOGIN

class LoginSubscreen2 extends StatefulWidget {
  @override
  State<LoginSubscreen2> createState() => _LoginSubscreen2State();
}

class _LoginSubscreen2State extends State<LoginSubscreen2> {
  var emailAddress = '';
  var password = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
          'Login',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Submit your email and password.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  emailAddress = value;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () async {
                  var iserror = 0;
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailAddress, password: password);
                  } on FirebaseAuthException catch (e) {
                    iserror = 1;
                    if (e.code == 'user-not-found') {
                      Fluttertoast.showToast(
                          msg: 'No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      Fluttertoast.showToast(
                          msg: 'Wrong password provided for that user.');
                    }
                  }
                  if (iserror == 0) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('email', emailAddress);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ));
                  } else {
                    Fluttertoast.showToast(msg: 'some error');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Submit'),
                )),
          ],
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}

//CREATE ACCOUNT

class LoginSubscreen3 extends StatefulWidget {
  const LoginSubscreen3({super.key});

  @override
  State<LoginSubscreen3> createState() => _LoginSubscreen3State();
}

class _LoginSubscreen3State extends State<LoginSubscreen3> {
  var emailAddress = '';
  var password = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
          'Create account',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Submit your email and password to create an account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  emailAddress = value;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () async {
                  var iserror = 0;
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailAddress,
                      password: password,
                    );
                  } on FirebaseAuthException catch (e) {
                    iserror = 1;
                    if (e.code == 'weak-password') {
                      Fluttertoast.showToast(
                          msg: 'The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      Fluttertoast.showToast(
                          msg: 'The account already exists for that email.');
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: '$e');
                  }
                  if (iserror == 0) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('email', emailAddress);

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Create'),
                )),
          ],
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:carparking/ui/general/LoginScreen.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginInScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  height: 250,
                  child: Image.asset('assets/images/ic_launcher.png')),
              SizedBox(
                height: 5,
              ),
              Text(
                'CarParking',
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green, fontStyle: FontStyle.italic),
              ),
            ],
          )),
    );
  }
}

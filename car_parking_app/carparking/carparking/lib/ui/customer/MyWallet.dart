import 'dart:async';

import 'package:carparking/ui/general/LoginScreen.dart';
import 'package:flutter/material.dart';


class MyWallet extends StatefulWidget {

  String credit  = "";


  MyWallet(this.credit);

  @override
  _MyWalletState createState() => _MyWalletState(credit);
}

class _MyWalletState extends State<MyWallet> {
  String credit  = "";


  _MyWalletState(this.credit);

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.green,
        backgroundColor: Colors.green,
        title: Row(
          children: <Widget>[
            Text(
              "Wallet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [],
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                'My Credit',
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green, fontStyle: FontStyle.italic),
              ),
              Text(
                credit,
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green, fontStyle: FontStyle.italic),
              ),
            ],
          )),
    );
  }
}

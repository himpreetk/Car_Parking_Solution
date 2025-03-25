import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/UserInfoModel.dart';
import 'package:carparking/models/UsersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyInfo extends StatefulWidget {
  String header_title = "";
  UserInfoModel _usersModel;

  MyInfo(this.header_title, this._usersModel);

  @override
  _MyInfoState createState() =>
      _MyInfoState(header_title, this._usersModel);
}

class _MyInfoState extends State<MyInfo> {
  bool isChecked = false;

  String appBartitle = "";
  UserInfoModel _usersModel;

  TextEditingController user_nameController = TextEditingController();
  TextEditingController user_emailController = TextEditingController();
  TextEditingController user_phone_noController = TextEditingController();
  TextEditingController user_locationController = TextEditingController();

  _MyInfoState(this.appBartitle, this._usersModel);

  FirebaseDBHelper _dbHelper = new FirebaseDBHelper();

  @override
  Future<void> initState() {
    initVals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              appBartitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: showAccountInfo(),
          ),
        ),
      ),
    );
  }

  Widget showAccountInfo() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  height: 80,
                  width: 80,
                  child: Image.asset("assets/images/profile.png")),
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Icon(Icons.credit_card),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('${_usersModel.credit.toString() ?? "Empty"}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13))),
                ],
              ),


            ],
          ),

          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.white,
            ),
            margin:
                const EdgeInsets.only(top: 20, left: 2, right: 2, bottom: 2),
            child: TextFormField(
                keyboardType: TextInputType.text,
                controller: user_nameController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Name",
                    border: OutlineInputBorder()),
                onChanged: (val) {

                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(2.0),
            child: TextFormField(
                keyboardType: TextInputType.text,
                controller: user_emailController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Email",
                    border: OutlineInputBorder()),
                onChanged: (val) {

                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(2.0),
            child: TextFormField(
                keyboardType: TextInputType.text,
                controller: user_phone_noController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Phone No.",
                    border: OutlineInputBorder()),
                onChanged: (val) {

                }),
          ),Container(
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.white,
            ),
            margin: const EdgeInsets.all(2.0),
            child: TextFormField(
                keyboardType: TextInputType.text,
                controller: user_locationController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Location",
                    border: OutlineInputBorder()),
                onChanged: (val) {

                }),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 60.0,
              left: 50.0,
              right: 50.0,
            ),
            child: RaisedButton(
              color: getColor(false),
              padding: EdgeInsets.all(15),
              onPressed: () {
              },
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Color getColor(bool color) {
    if (color == false) {
      return Colors.grey;
    } else if (color == true) {
      return Colors.green;
    } else {
      return Colors.yellowAccent.shade400;
    }
  }

  initVals() async{
    user_nameController.text = _usersModel.user_name;
    user_emailController.text = _usersModel.user_email;
    user_locationController.text = _usersModel.location;
    user_phone_noController.text = _usersModel.user_contact;
  }
}

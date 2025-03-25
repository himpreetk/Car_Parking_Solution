import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/utils/Firebase_Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'LoginScreen.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage();
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  static var key = new GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditController =
  new TextEditingController();
  TextEditingController emailTextEditController = new TextEditingController();
  TextEditingController passTextEditingController = new TextEditingController();
  TextEditingController contact_no_TextEditController = new TextEditingController();
  TextEditingController vehicle_no_TextEditController = new TextEditingController();

  Firebase_Authentication _firebase_authentication =
  new Firebase_Authentication();
  FirebaseDBHelper _firebaseDBHelper = new FirebaseDBHelper();
  String _character = "Customer";
  List<String> locations = [];
  String dropdownVal;

  @override
  void initState() {
    addLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              // height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 0, right: 0, top: 60, bottom: 10),
                          height: 100,
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Container(
                            child: Image.asset('assets/images/ic_launcher.png'),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          left: 40.0,
                          right: 40.0,
                        ),
                        child: Text(
                          'CarParking',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),

                    UserBasicInfo(),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 20.0,
                        left: 50.0,
                        right: 50.0,
                      ),
                      child: RaisedButton(
                        color: Colors.green,
                        padding: EdgeInsets.all(15),
                        onPressed: () {
                          signUpRequest();
                        },
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showSnackBar(String text) {
    key.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  signUpRequest() async {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "user_name": nameTextEditController.text,
        "user_email": emailTextEditController.text.trim(),
        "user_group": _character,
        "user_contact": contact_no_TextEditController.text,
        "location": dropdownVal,
        "active_status": "true",
        "vehicle_no": vehicle_no_TextEditController.text,
        "credit": "0",
      };

      setState(() {
        isLoading = true;
      });
      _firebase_authentication
          .signUpWithEmailAndPassword(
          emailTextEditController.text.trim(), passTextEditingController.text)
          .then((val) async {
        if (_character == "Customer") {
          await _firebaseDBHelper.saveActiveUser(userInfoMap);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: 'SignUp',
            desc: 'SignedUp Successful',
            btnOkOnPress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginInScreen()));
            },
          )..show();
        } else if(_character == "Parking Manager"){
          _firebaseDBHelper.saveNewPkMang(userInfoMap);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: 'SignUp',
            desc: 'Wait for the Approval from Administration',
            btnOkOnPress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginInScreen()));
            },
          )..show();
        } else if(_character == "Valet"){
          _firebaseDBHelper.saveNewPkValet(userInfoMap);

          AwesomeDialog(
            context: context,
            dialogType: DialogType.SUCCES,
            title: 'SignUp',
            desc: 'Wait for the Approval from Administration',
            btnOkOnPress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginInScreen()));
            },
          )..show();
        }


      });
    }
  }

  Widget UserBasicInfo() {
    return Container(
      margin: EdgeInsets.only(left: 10.0, right: 10, top: 20, bottom: 10),
      width: double.infinity,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: Color(0xFFFFFFFF),
        boxShadow: [
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 50.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
                left: 10.0, right: 10, bottom: 0, top: 20),
            child: TextFormField(
              keyboardType: TextInputType.name,
              validator: (val) {
                return val.length > 3 ? null : "Please enter a valid Name";
              },
              controller: nameTextEditController,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(
                  color: Color(0xFFb1b2c4),
                ),
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.05),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 25.0,
                ),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Color(0xFF000000),
                ),
                //
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                left: 10.0, right: 10, bottom: 2, top: 2),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                return val.length > 6
                    ? null
                    : "Please enter a valid email address";
              },
              controller: emailTextEditController,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: 'email_address@mail.com',
                hintStyle: TextStyle(
                  color: Color(0xFFb1b2c4),
                ),
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.05),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 25.0,
                ),
                prefixIcon: Icon(
                  Icons.email_sharp,
                  color: Color(0xFF000000),
                ),
                //
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 2.0,
            ),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              validator: (val) {
                return val.length > 6
                    ? null
                    : "Password must be greater than 6 characters";
              },
              controller: passTextEditingController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'password',
                hintStyle: TextStyle(
                  color: Color(0xFFb1b2c4),
                ),
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.05),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 25.0,
                ),
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: Color(0xFF000000),
                ),
                //
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                left: 10.0, right: 10, bottom: 2, top: 0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (val) {
                return val.length > 10
                    ? null
                    : "Please enter a valid number";
              },
              controller: contact_no_TextEditController,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: 'Contact no',
                hintStyle: TextStyle(
                  color: Color(0xFFb1b2c4),
                ),
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.05),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 25.0,
                ),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Color(0xFF000000),
                ),
                //
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(
                left: 10.0, right: 10, bottom: 2, top: 0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              validator: (val) {
                return val.length > 2
                    ? null
                    : "Please enter a valid number";
              },
              controller: vehicle_no_TextEditController,
              textCapitalization: TextCapitalization.none,
              decoration: InputDecoration(
                hintText: 'vehicle no',
                hintStyle: TextStyle(
                  color: Color(0xFFb1b2c4),
                ),
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.05),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 25.0,
                ),
                prefixIcon: Icon(
                  Icons.info,
                  color: Color(0xFF000000),
                ),
                //
              ),
            ),
          ),

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: "Customer",
                          groupValue: _character,
                          onChanged: (String value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        Text("Customer"),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: "Parking Manager",
                          groupValue: _character,
                          onChanged: (String value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        Text("Parking Manager"),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: "Valet",
                          groupValue: _character,
                          onChanged: (String value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        Text("Valet"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          DropdownButton<String>(
            value: dropdownVal,
            hint: Text('Select Location'),
            icon: Icon(
              Icons.arrow_downward,
              color: Colors.black,
            ),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownVal = newValue;
              });
            },
            items: locations.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  addLocations() async{


    QuerySnapshot parkingSnapshot =
    await FirebaseDBHelper().getParking();
    for (int i = 0; i < parkingSnapshot.docs.length; i++) {
      locations.add(parkingSnapshot.docs[i].data()["parking_name"]);

    }

    dropdownVal = locations.first;
    setState(() {
    });
  }
}

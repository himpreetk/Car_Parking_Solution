
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/Menu.dart';
import 'package:carparking/ui/general/MainMenu.dart';
import 'package:carparking/utils/Firebase_Authentication.dart';
import 'package:carparking/utils/SharedPref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'SignUpScreen.dart';

class LoginInScreen extends StatefulWidget {
  LoginInScreen();

  @override
  _LoginInScreenState createState() => _LoginInScreenState();
}

class _LoginInScreenState extends State<LoginInScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  List<Menu> listOfMenu = [];
  String title = "";

  Firebase_Authentication _firebase_authentication =
  new Firebase_Authentication();

  String userEmail = "";
  String username = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _child;
    if (isLoading == true) {
      _child = const Center(child: CircularProgressIndicator());
    } else if (isLoading == false) {
      _child = loginWidget();
    }

    return Scaffold(body: _child);
  }

  loadMainMenu(String user_group, String user_contact, String user_location) async {
    await createMenulist(user_group);
    isLoading = false;
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainMenu(listOfMenu, title, user_group, user_contact, user_location),
      ),
    );
  }

  createMenulist(String group) async {
    listOfMenu.clear();


    if (group == "Admin") {
      listOfMenu.add(new Menu("assets/images/approve_manager.png", "Approve Prk. Manager"));
      listOfMenu.add(new Menu("assets/images/add_parking.png", "Add Parking"));
      listOfMenu.add(new Menu("assets/images/manage_user.png", "User Management"));


      title = "Admin";
    } else if (group == "Customer") {
      listOfMenu.add(new Menu("assets/images/profile.png", "My Info"));
      listOfMenu.add(new Menu("assets/images/parking.png", "Parking"));
      listOfMenu.add(new Menu("assets/images/contac_user.png", "Contact Other"));
      listOfMenu.add(new Menu("assets/images/wallet.png", "Wallet"));

      title = "Customer";
    } else if (group == "Parking Manager") {
      listOfMenu.add(new Menu("assets/images/valet.png", "Add Valet"));
      listOfMenu.add(new Menu("assets/images/valet.png", "Valet Manager"));
      listOfMenu.add(new Menu("assets/images/business_credit_score.png", "Topup credit"));
      listOfMenu.add(new Menu("assets/images/fine_money.png", "Fine customer"));
      listOfMenu.add(new Menu("assets/images/winner.png", "Give Points"));
      listOfMenu.add(new Menu("assets/images/contac_user.png", "Contact User"));

      title = "Parking Manager";
    } else if (group == "Valet") {
      listOfMenu.add(new Menu("assets/images/business_credit_score.png", "Topup credit"));
      listOfMenu.add(new Menu("assets/images/winner.png", "Give Points"));
      listOfMenu.add(new Menu("assets/images/contac_user.png", "Contact User"));

      title = "Valet";
    }
  }

  applyLogin() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });


      await _firebase_authentication
          .signInWithEmailAndPassword(
              emailController.text.trim(), passwordController.text.trim())
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await FirebaseDBHelper().getActiveUserByEmail(emailController.text.trim());
          if (userInfoSnapshot != null && userInfoSnapshot.docs.length > 0) {
            SharedPref.saveNameSharedPreference(
                userInfoSnapshot.docs[0].data()["user_name"]);
            SharedPref.saveUserEmailSharedPreference(
                userInfoSnapshot.docs[0].data()["user_email"]);


            SharedPref.saveUserGroupSharedPreference(userInfoSnapshot.docs[0].data()["user_group"]);
            print(userInfoSnapshot.docs[0].data()["user_group"]);


            SharedPref.saveVehicleNoSharedPreference(userInfoSnapshot.docs[0].data()["vehicle_no"]);




            await loadMainMenu(userInfoSnapshot.docs[0].data()["user_group"],
                userInfoSnapshot.docs[0].data()["user_contact"],
                userInfoSnapshot.docs[0].data()["location"]
            );
          } else {
            setState(() {
              isLoading = false;
              // TODO
            });

            AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              title: 'Login',
              desc: 'Not a approved user.',
              btnCancelOnPress: () {},
              btnOkOnPress: () {},
            )..show();
          }
        } else {
          setState(() {
            isLoading = false;
            // TODO
          });

          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            title: 'Login',
            desc: 'Email or Password incorrect.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        }
      });
    }
  }

  Widget loginWidget() {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 0, right: 0, top: 100, bottom: 10),
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
                            'CarParking App',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 30),
                        width: double.infinity,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white,
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
                              margin: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  return val.length > 6
                                      ? null
                                      : "Email missing";
                                },
                                controller: emailController,
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
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.05),
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
                                left: 20.0,
                                right: 20.0,
                                bottom: 20.0,
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                validator: (val) {
                                  return val.length > 6
                                      ? null
                                      : "Password missing";
                                },
                                controller: passwordController,
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
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.05),
                                  prefixIcon: Icon(
                                    Icons.lock_rounded,
                                    color: Color(0xFF000000),
                                  ),
                                  //
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 60.0,
                    left: 50.0,
                    right: 50.0,
                  ),
                  child: RaisedButton(
                    color: Colors.green,
                    padding: EdgeInsets.all(15),
                    onPressed: () async {
                      applyLogin();
                    },
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Click here for Register',
                        style: new TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

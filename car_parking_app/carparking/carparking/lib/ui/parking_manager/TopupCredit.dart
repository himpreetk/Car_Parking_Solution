import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/UsersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TopupCredit extends StatefulWidget {
  String header_title = "";
  String userEmail = "";
  String username = "";
  String user_contact, user_location;

  TopupCredit(this.header_title, this.userEmail, this.username, this.user_contact, this.user_location);

  @override
  _TopupCreditState createState() =>
      _TopupCreditState(header_title, userEmail, username, this.user_contact, this.user_location);
}

class _TopupCreditState extends State<TopupCredit> {
  bool isChecked = false;
  bool isLoading = false;
  String customer_selected = "no";

  String appBartitle = "";
  String userEmail = "";
  String username = "";
  String user_contact, user_location = "";
  String name = "",
      email = "",
      phone_no = "",
      location = "",
      credit = "",
  active_status, user_group;
  bool enableSave = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phone_noController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController creditController = TextEditingController();
  List<UsersModel> usersList = [];

  _TopupCreditState(this.appBartitle, this.userEmail, this.username, this.user_contact, this.user_location);

  FirebaseDBHelper _dbHelper = new FirebaseDBHelper();
  UsersModel selected_customer_model;

  @override
  Future<void> initState() {
    // getAccountInfo();
    getCustomers();
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
            child: customer_selected=="yes"?showAccountInfo():usersListData(),
          ),
        ),
      ),
    );
  }


  Widget usersListData() {
    return Container(
      width: double.infinity,
      child: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
          shrinkWrap: true,
          itemCount: usersList.length,
          itemBuilder: (BuildContext context, int index) {
            UsersModel usersModel = usersList.elementAt(index);
            return GestureDetector(
                child: buildList(context, index, usersModel),
                onTap: () => onTapped());
          }),
    );
  }

  Widget buildList(BuildContext context, int index, UsersModel usersModel) {
    return GestureDetector(
      child: Card(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          width: double.infinity,
//      height: 150,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${usersModel.user_name.toString().toUpperCase() ?? "Empty"}',
                      style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    new Row(
                      children: <Widget>[
                        Text('Email: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: .3,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('${usersModel.user_email.toString() ?? "Empty"}',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: .3,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Text('Parking: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: .3,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('${usersModel.location.toString() ?? "Empty"}',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: .3,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        Text('Contact: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              letterSpacing: .3,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('${usersModel.user_contact.toString() ?? "Empty"}',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: .3,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    ),

                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                    color: Colors.green.shade700)),
                            color: Colors.green,
                            child: Text(
                              "Topup",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              selected_customer_model = usersList.elementAt(index);

                              name = selected_customer_model.user_name;
                              nameController.text = name;

                              email = selected_customer_model.user_email;
                              emailController.text = email;

                              phone_no = selected_customer_model.user_contact;
                              phone_noController.text=phone_no;

                              location = selected_customer_model.location;
                              locationController.text=location;

                              active_status = selected_customer_model.active_status;
                              user_group = selected_customer_model.user_group;

                             customer_selected = "yes";
                             setState(() {

                             });
                            }),

                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }

  onTapped() {}

  Widget showAccountInfo() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.white,
            ),
            margin:
                const EdgeInsets.only(top: 20, left: 2, right: 2, bottom: 2),
            child: TextFormField(
                keyboardType: TextInputType.number,
                controller: creditController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Credit",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    credit = val;
                  } else {
                    credit = "";
                  }
                }),
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
                controller: nameController,
                enabled: false,

                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Name",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    name = val;
                  } else {
                    name = "";
                  }
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
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                enabled: false,

                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Email",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    email = val;
                  } else {
                    email = "";
                  }
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
                controller: locationController,
                enabled: false,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Location",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    location = val;
                  } else {
                    location = "";
                  }
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
                keyboardType: TextInputType.number,
                controller: phone_noController,
                enabled: false,

                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Phone No.",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    phone_no = val;
                  } else {
                    phone_no = "";
                  }
                }),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 60.0,
              left: 50.0,
              right: 50.0,
            ),
            child: RaisedButton(
              color: getColor(enableSave),
              padding: EdgeInsets.all(15),
              onPressed: () {
                if(credit.isNotEmpty) {
                  saveAccountInfo();
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Add credit first"),
                  ));
                }
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

  saveAccountInfo() async {
    Map<String, String> accountMap = {
      "user_name": name,
      "user_email": email,
      "user_group": user_group,
      "user_contact": phone_no,
      "location": location,
      "credit": credit,
      "points": "0",
      "active_status": active_status,
    };


    await _dbHelper.saveUserInfo(accountMap);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Credit topup successfully"),
    ));
    Navigator.pop(context);
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

  getCustomers() async{
    QuerySnapshot usersSnapshot = await FirebaseDBHelper().getActiveUserByGroup("Customer");
    for (int i = 0; i < usersSnapshot.docs.length; i++) {
      if (usersSnapshot.docs[i].data()["location"] == user_location) {
        usersList.add(new UsersModel(
          usersSnapshot.docs[i].data()["user_email"],
          usersSnapshot.docs[i].data()["user_group"],
          usersSnapshot.docs[i].data()["user_name"],
          usersSnapshot.docs[i].data()["user_contact"],
          usersSnapshot.docs[i].data()["location"],
          usersSnapshot.docs[i].data()["active_status"],
          usersSnapshot.docs[i].data()["vehicle_no"],
        ));
      }
    }
    print(usersList.length);
    setState(() {});
  }
}

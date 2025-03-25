import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/UsersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactOther extends StatefulWidget {
  String appBartitle = "";
  String userEmail = "";
  String username = "";
  String userContact = "";

  ContactOther(this.appBartitle, this.userEmail, this.username, this.userContact);

  @override
  _ContactOtherState createState() =>
      _ContactOtherState(appBartitle, userEmail, username, userContact);
}

class _ContactOtherState extends State<ContactOther> {
  String appBartitle = "";
  String userEmail = "";
  String username = "";
  String vehicle_no = "";
  String userContact = "";
  bool isLoading = false;


  TextEditingController vehicle_no_Controller = TextEditingController();

  List<UsersModel> usersList = [];

  _ContactOtherState(this.appBartitle, this.userEmail, this.username, this.userContact);

  @override
  void initState() {
    getSocietyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.green,
        backgroundColor: Colors.green,
        title: Row(
          children: <Widget>[
            Text(
              appBartitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: createCatWidget(),
          ),
        ),
      ),
    );
  }

  Widget createCatWidget() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.0),
            color: Colors.white,
          ),
          margin: const EdgeInsets.only(top: 20, left: 2, right: 2, bottom: 2),
          child: TextFormField(
              keyboardType: TextInputType.text,
              controller: vehicle_no_Controller,
              decoration: InputDecoration(
                  isDense: true,
                  labelText: "Enter vehicle no",
                  border: OutlineInputBorder()),
              onChanged: (val) {
                if (val.isNotEmpty) {
                  vehicle_no = val;
                } else {
                  vehicle_no = "";
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
            color: Colors.green,
            padding: EdgeInsets.all(15),
            onPressed: () {

              getSocietyList();
            },
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Get Contact Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Divider(),
        customersListData(),
      ],
    );
  }

  Widget customersListData() {
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
                              "Call User",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              launch("tel://"+usersModel.user_contact);;
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


  getSocietyList() async {
    QuerySnapshot usersSnapshot = await FirebaseDBHelper().getActiveUserByVehcileNo(vehicle_no);
    for (int i = 0; i < usersSnapshot.docs.length; i++) {
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
    print(usersList.length);
    setState(() {});
  }
}

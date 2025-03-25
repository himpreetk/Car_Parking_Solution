import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/UsersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddValet extends StatefulWidget {
  String appBartitle = "";
  String userEmail = "";
  String username = "", user_contact, user_location;

  AddValet(this.appBartitle, this.userEmail, this.username,this.user_contact, this.user_location);

  @override
  _AddValetState createState() =>
      _AddValetState(appBartitle, userEmail, username, user_contact, user_location);
}

class _AddValetState extends State<AddValet> {
  String appBartitle = "";
  String userEmail = "";
  String username = "",user_contact, user_location;
  bool isLoading = false;
  List<UsersModel> usersList = [];
  FirebaseDBHelper _firebaseDBHelper = new FirebaseDBHelper();

  _AddValetState(this.appBartitle, this.userEmail, this.username,this.user_contact, this.user_location);

  @override
  void initState() {
    getNewPkValets();
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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          valetListData(),
        ],
      )),
    );
  }

  getNewPkValets() async {
    QuerySnapshot pkvaletSnapshot = await FirebaseDBHelper().getNewPkValet();
    for (int i = 0; i < pkvaletSnapshot.docs.length; i++) {
      if (pkvaletSnapshot.docs[i].data()["user_group"] == "Valet") {
        usersList.add(new UsersModel(
          pkvaletSnapshot.docs[i].data()["user_email"],
          pkvaletSnapshot.docs[i].data()["user_group"],
          pkvaletSnapshot.docs[i].data()["user_name"],
          pkvaletSnapshot.docs[i].data()["user_contact"],
          pkvaletSnapshot.docs[i].data()["location"],
          pkvaletSnapshot.docs[i].data()["active_status"],
          pkvaletSnapshot.docs[i].data()["vehicle_no"],
        ));
      }
    }
    print(usersList.length);
    setState(() {});
  }

  Widget valetListData() {
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
                              "Add Valet",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              activeUser(usersModel);
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

  activeUser(UsersModel usersModel) async {
    ////////////selecting ///////////////
    Map<String, String> userInfoMap = {
      "user_name": usersModel.user_name,
      "user_email": usersModel.user_email,
      "user_group": usersModel.user_group,
      "user_contact": usersModel.user_contact,
      "location": usersModel.location,
      "active_status": "true",
      "vehicle_no": usersModel.vehicle_no,

    };


    _firebaseDBHelper.saveActiveUser(userInfoMap);

    /////////////delete/////////////////

    QuerySnapshot usersSnapshot = await FirebaseDBHelper().getNewPkValet();
    for (int i = 0; i < usersSnapshot.docs.length; i++) {
      if (usersSnapshot.docs[i].data()["user_email"] == usersModel.user_email) {
        final collection =
            FirebaseFirestore.instance.collection('new_valet_users');
        collection
            .doc(usersSnapshot.docs[i].id) // <-- Doc ID to be deleted.
            .delete() // <-- Delete
            .then((_) => {print('Deleted')})
            .catchError((error) => print('Delete failed: $error'));
      }
    }

    /////////////delete/////////////////

    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      title: 'New Valet',
      desc: 'New valet added in your team',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
    ////////////selecting ///////////////
  }
}

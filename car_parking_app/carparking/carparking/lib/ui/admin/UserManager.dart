import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/UsersModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserManager extends StatefulWidget {
  String appBartitle = "";
  String userEmail = "";
  String username = "", user_contact, user_location;

  UserManager(this.appBartitle, this.userEmail, this.username,user_contact, user_location);

  @override
  _UserManagerState createState() =>
      _UserManagerState(appBartitle, userEmail, username,user_contact, user_location);
}

class _UserManagerState extends State<UserManager> {
  String appBartitle = "";
  String userEmail = "";
  String username = "",user_contact, user_location;
  bool isLoading = false;
  List<UsersModel> usersList = [];
  FirebaseDBHelper _firebaseDBHelper = new FirebaseDBHelper();

  _UserManagerState(this.appBartitle, this.userEmail, this.username, this.user_contact, this.user_location);

  @override
  void initState() {
    getActiveUserByGroups();
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
          usersListData(),
        ],
      )),
    );
  }

  getActiveUserByGroups() async {
    QuerySnapshot usersSnapshot = await FirebaseDBHelper().getActiveUserByGroup("Parking Manager");
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
                              changeStatus(usersModel.active_status),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              if(usersModel.active_status=="true"){
                                activeUser(usersModel, "false");

                              }else  if(usersModel.active_status=="false"){
                                activeUser(usersModel, "true");

                              }
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
  String getStatus(String currentStatus) {
    if(currentStatus=="true"){
      return 'Active';
    }else{
      return 'Deactive';
    }
  }

  String changeStatus(String currentStatus) {
    if(currentStatus=="false"){
      return 'Active';
    }else{
      return 'Deactive';
    }
  }


  onTapped() {}

  activeUser(UsersModel usersModel, String status) async {



    print('enter');

    /////////////delete/////////////////

    QuerySnapshot usersSnapshot = await FirebaseDBHelper().getActiveUserByGroup("Parking Manager");
    for (int i = 0; i < usersSnapshot.docs.length; i++) {
      if (usersSnapshot.docs[i].data()["user_email"] == usersModel.user_email) {
        final collection =
        FirebaseFirestore.instance.collection('active_users');
        collection
            .doc(usersSnapshot.docs[i].id) // <-- Doc ID to be deleted.
            .delete() // <-- Delete
            .then((_) => {print('Deleted')})
            .catchError((error) => print('Delete failed: $error'));
      }
    }

    /////////////delete/////////////////

    ////////////selecting ///////////////
    Map<String, String> userInfoMap = {
      "user_name": usersModel.user_name,
      "user_email": usersModel.user_email,
      "user_group": usersModel.user_group,
      "user_contact": usersModel.user_contact,
      "location": usersModel.location,
      "active_status": status,
      "vehicle_no": usersModel.vehicle_no,
    };

    _firebaseDBHelper.saveActiveUser(userInfoMap);


    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      // animType: AnimType.BOTTOMSLIDE,
      title: 'User manager',
      desc: 'User is now'+ getStatus(status),
      // btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
    ////////////selecting ///////////////
  }
}

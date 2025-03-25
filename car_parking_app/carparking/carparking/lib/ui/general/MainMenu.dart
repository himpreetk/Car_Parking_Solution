
import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/Menu.dart';
import 'package:carparking/models/UserInfoModel.dart';
import 'package:carparking/models/UsersModel.dart';
import 'package:carparking/ui/admin/AddParking.dart';
import 'package:carparking/ui/admin/ApprovePkManager.dart';
import 'package:carparking/ui/admin/UserManager.dart';
import 'package:carparking/ui/customer/MyInfo.dart';
import 'package:carparking/ui/customer/MyWallet.dart';
import 'package:carparking/ui/customer/SelectParking.dart';
import 'package:carparking/ui/general/ContactOther.dart';
import 'package:carparking/ui/parking_manager/AddValet.dart';
import 'package:carparking/ui/parking_manager/FineCustomer.dart';
import 'package:carparking/ui/parking_manager/GivePoints.dart';
import 'package:carparking/ui/parking_manager/TopupCredit.dart';
import 'package:carparking/ui/parking_manager/ValetManager.dart';
import 'package:carparking/utils/SharedPref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';




class MainMenu extends StatefulWidget {
  List<Menu> rightsList = [];
  String appBartitle;
  String group;
  String user_contact, user_location;

  MainMenu(this.rightsList, this.appBartitle, this.group, this.user_contact, this.user_location);

  @override
  _MainMenuState createState() =>
      _MainMenuState(rightsList, appBartitle, group, user_contact, user_location);
}

class _MainMenuState extends State<MainMenu> {
  static var key = new GlobalKey<ScaffoldState>();
  List<Menu> user_rights = [];
  static String userEmail = "";

  String username = "", user_group='', active_status='', credit='0', location='', vehicle_no='';
  String appBartitle;
  String group;
  String user_contact, user_location;
  UserInfoModel _usersModel;


  _MainMenuState(this.user_rights, this.appBartitle, this.group, this.user_contact, this.user_location);

  @override
  void initState() {
    getUserEmail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
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
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height / 1,

        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height / 1.1,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              basicInfo(),
              Container(
                height: MediaQuery.of(context).size.height / 1.6,
                child: Container(
                  // height: MediaQuery.of(context).size.height / 1.2,
                    child: showMenuItems()),
              ),
            ],),
          ),
        ),
      )
    );
  }

  gotoNextScreen(Menu menusModel) {
    if (menusModel.menu_name == "Approve Prk. Manager") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ApprovePkManager(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }else if (menusModel.menu_name == "Add Valet") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddValet(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }else if (menusModel.menu_name == "User Management") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              UserManager(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }else if (menusModel.menu_name == "Valet Manager") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ValetManager(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }else if (menusModel.menu_name == "Add Parking") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AddParking(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }else if (menusModel.menu_name == "My Info") {
      if(_usersModel!=null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MyInfo(menusModel.menu_name, _usersModel),
          ),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please topup your wallet first"),
        ));
      }
    }else if (menusModel.menu_name == "Topup credit") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TopupCredit(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }else if (menusModel.menu_name == "Wallet") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyWallet(credit),
        ),
      );
    }else if (menusModel.menu_name == "Contact Other") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ContactOther(menusModel.menu_name, userEmail, username, user_contact),
        ),
      );
    }else if (menusModel.menu_name == "Parking") {
      if(_usersModel!=null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SelectParking(menusModel.menu_name, _usersModel),
          ),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please topup your wallet first"),
        ));
      }

    }else if (menusModel.menu_name == "Contact User") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ContactOther(menusModel.menu_name, userEmail, username, user_contact),
        ),
      );
    }else if (menusModel.menu_name == "Fine customer") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FineCustomer(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }else if (menusModel.menu_name == "Give Points") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GivePoints(menusModel.menu_name, userEmail, username, user_contact, user_location),
        ),
      );
    }


  }

  Widget basicInfo() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(top: 2, bottom: 2),
                child: Image.asset('assets/images/profile.png'),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  username.toUpperCase(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Vehicle Number:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  vehicle_no,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),

          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Icon(Icons.location_city),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(user_location,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13))),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Icon(Icons.contact_phone),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(user_contact,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13))),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(top: 2, bottom: 2),
                    child: Icon(Icons.credit_card),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(credit,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  getUserEmail() async {
    var Email = await SharedPref.getUserEmailSharedPreference();

    userEmail = Email;

    var Username = await SharedPref.getNameSharedPreference();

    username = Username;

    var Vehicle_No = await SharedPref.getVehicleNoSharedPreference();

    vehicle_no = Vehicle_No;
    if(vehicle_no==null){
      vehicle_no='';
    }







    QuerySnapshot accountInfoSnapshot =
    await FirebaseDBHelper().getUserInfoByEmail(userEmail);
    if (accountInfoSnapshot.docs.length > 0) {
      userEmail = accountInfoSnapshot.docs[0].data()["user_email"];
      username = accountInfoSnapshot.docs[0].data()["user_name"];
      user_contact = accountInfoSnapshot.docs[0].data()["user_contact"];
      user_group = accountInfoSnapshot.docs[0].data()["user_group"];
      active_status = accountInfoSnapshot.docs[0].data()["active_status"];
      credit = accountInfoSnapshot.docs[0].data()["credit"];
      location = accountInfoSnapshot.docs[0].data()["location"];

      _usersModel = new UserInfoModel(
          userEmail, user_group, username, user_contact, location,
          active_status, credit);



      setState(() {

      });
    }
  }
  Widget showMenuItems() {
    return GridView.count(
      shrinkWrap: true,
      childAspectRatio: 2 / 1.4,
      crossAxisCount: 2,
      children: List.generate(user_rights.length, (index) {
        return Container(
          child: GestureDetector(
            onTap: () {
              gotoNextScreen(user_rights.elementAt(index));
            },
            child: Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            child: Image.asset(
                                user_rights.elementAt(index).menu_icon)),
                        Text(
                          user_rights.elementAt(index).menu_name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        );
      }),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDBHelper {
  var dbReference = FirebaseDatabase.instance.reference();


  //live users


  saveActiveUser(userMap) async{
    FirebaseFirestore.instance
        .collection("active_users")
        .add(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }
  getActiveUserByEmail(String email) async {
    return FirebaseFirestore.instance
        .collection("active_users")
        .where("user_email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getActiveUser() async {
    return FirebaseFirestore.instance
        .collection("active_users")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getActiveUserByGroup(String user_group) async {
    return FirebaseFirestore.instance
        .collection("active_users")
        .where("user_group", isEqualTo: user_group)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getActiveUserByVehcileNo(String vehicle_no) async {
    return FirebaseFirestore.instance
        .collection("active_users")
        .where("vehicle_no", isEqualTo: vehicle_no)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }




  //pk manager
  saveNewPkMang(pkMangMap) async{
    FirebaseFirestore.instance
        .collection("new_pkmgr_users")
        .add(pkMangMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getNewPkMang() async{
    return FirebaseFirestore.instance
        .collection("new_pkmgr_users")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  //pk manager
  saveNewPkValet(valetMap) async{
    FirebaseFirestore.instance
        .collection("new_valet_users")
        .add(valetMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getNewPkValet() async{
    return FirebaseFirestore.instance
        .collection("new_valet_users")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  //save parking
  saveParkingInfo(parkingMap) {
    FirebaseFirestore.instance
        .collection("parking")
        .add(parkingMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getParkingByName(String parking_name) async {
    return FirebaseFirestore.instance
        .collection("parking")
        .where("parking_name", isEqualTo: parking_name)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getParking() async {
    return FirebaseFirestore.instance
        .collection("parking")
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }



  //save parking column
  saveParkingColumnInfo(parkingMap) {
    FirebaseFirestore.instance
        .collection("parking_column")
        .add(parkingMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getParkingColumnByName(String parking_name) async {
    return FirebaseFirestore.instance
        .collection("parking_column")
        .where("parking_name", isEqualTo: parking_name)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  //save parking column
  saveParkingRowType(parkingRowMap) {
    FirebaseFirestore.instance
        .collection("parking_row_type")
        .add(parkingRowMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getParkingRowTypeByName(String parking_name) async {
    return FirebaseFirestore.instance
        .collection("parking_row_type")
        .where("parking_name", isEqualTo: parking_name)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  //save parking column
  saveBookingSlot(bookingMap) {
    FirebaseFirestore.instance
        .collection("booking_slot")
        .add(bookingMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getBookingSlotByName(String parking_name) async {
    return FirebaseFirestore.instance
        .collection("booking_slot")
        .where("parking_name", isEqualTo: parking_name)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }



  saveUserInfo(userinfoMap) {
    FirebaseFirestore.instance
        .collection("userinfo")
        .add(userinfoMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfoByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("userinfo")
        .where("user_email", isEqualTo: userEmail)
        .get();
  }

}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/models/UserInfoModel.dart';
import 'package:carparking/models/UsersModel.dart';
import 'package:carparking/ui/customer/models/BookedParkingModel.dart';
import 'package:carparking/ui/customer/models/ParkingRowColModel.dart';
import 'package:carparking/ui/customer/models/ParkingRowModel.dart';
import 'package:carparking/ui/customer/models/ParkingRowTypeModel.dart';
import 'package:carparking/ui/customer/models/RowColValModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SelectParking extends StatefulWidget {
  String header_title = "";
  UserInfoModel _usersModel;
  String user_contact, user_location;

  SelectParking(this.header_title, this._usersModel);

  @override
  _SelectParkingState createState() =>
      _SelectParkingState(header_title, _usersModel);
}

class _SelectParkingState extends State<SelectParking> {
  bool isChecked = false;

  String appBartitle = "";
  String userEmail = "";
  String username = "";
  String user_contact, user_location = "";
  String parking_name = "", city = "", address = "", rows = "";
  bool enableSave = true;
  TextEditingController parking_nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController rowsController = TextEditingController();
  bool addColumn = false;

  //for list of parking
  // List<TextEditingController> _controllers = new List();
  TextEditingController col_controllers = new TextEditingController();
  List<String> parking_type = ['Car', 'Bike', 'Truck', 'Bus', 'Van'];
  List<ParkingRowModel> parking_row_list = [];
  int row_number = 1;
  String parkingDropdownVal;

  String select_parking_type = "Car";
  int parking_type_lable_index = 0;
  int parking_row_index = 0;
  List<String> list_parking_type = ['Car', 'Bike', 'Truck', 'Bus', 'Van'];
  UserInfoModel _usersModel;
  List<String> no_of_col_in_row = [];
  List<String> row_names = [];
  List<String> row_no_type = [];

  List<ParkingRowColModel> parkingRowCol_list = [];
  List<ParkingRowTypeModel> parkingRowType_list = [];
  ParkingRowModel parkingRowModel;
  int no_of_col = 0;
  List<RowColValModel> row_col_name_list = [];
  String row_select;

  _SelectParkingState(this.appBartitle, this._usersModel);

  FirebaseDBHelper _dbHelper = new FirebaseDBHelper();
  int selectedIndex;

  List<BookedParkingModel> listOfBookedParking = [];

  String bookingAction = "Book Slot";


  @override
  Future<void> initState() {
    getParkingInfo();

    parkingDropdownVal = parking_type.first;
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
            child: parkingInfo(),
          ),
        ),
      ),
    );
  }

  Widget parkingInfo() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          ToggleSwitch(
            initialLabelIndex: parking_type_lable_index,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.white12,
            inactiveFgColor: Colors.white,
            totalSwitches: 5,
            iconSize: 30.0,
            borderWidth: 2.0,
            labels: list_parking_type,
            borderColor: [Colors.green],
            activeBgColors: [
              [Colors.green.shade200],
              [Colors.green.shade200],
              [Colors.green.shade200],
              [Colors.green.shade200],
              [Colors.green.shade200]
            ],
            radiusStyle: true,
            minWidth: 90.0,
            cornerRadius: 20.0,
            onToggle: (index) {
              select_parking_type = list_parking_type[index];
              print(select_parking_type);
              parking_type_lable_index = index;
            },
          ),
          SizedBox(
            height: 10,
          ),
          row_names.length > 0
              ? ToggleSwitch(
                  initialLabelIndex: parking_row_index,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white12,
                  inactiveFgColor: Colors.white,
                  totalSwitches: row_names.length,
                  iconSize: 30.0,
                  borderWidth: 2.0,
                  labels: row_names,
                  borderColor: [Colors.green],

                  // activeBgColors: [
                  //   [Colors.pink.shade200],
                  //   [Colors.pink.shade200],
                  //   [Colors.pink.shade200],
                  //   [Colors.pink.shade200],
                  //   [Colors.pink.shade200]
                  // ],
                  radiusStyle: true,
                  minWidth: 90.0,
                  cornerRadius: 20.0,
                  onToggle: (index) {
                    row_col_name_list.clear();

                    parking_row_index = index;
                    row_select = row_names[index];

                    for (int i = 0; i < parkingRowCol_list.length; i++) {
                      if (parkingRowCol_list.elementAt(i).parking_row_name ==
                          row_select) {
                        no_of_col = int.parse(parkingRowCol_list
                            .elementAt(i)
                            .parking_row_col_val);
                      }
                    }
                    if (no_of_col > 0) {
                      for (int j = 0; j < no_of_col; j++) {
                        row_col_name_list.add(new RowColValModel(
                            (j + 1).toString(), 'unoccupied'));
                      }
                    }
                  },
                )
              : Container(),
          Divider(),
          Container(
            margin: const EdgeInsets.only(
              // top: 60.0,
              left: 50.0,
              right: 50.0,
            ),
            child: RaisedButton(
              color: getColor(enableSave),
              padding: EdgeInsets.all(15),
              onPressed: () {

                for (int i = 0; i < listOfBookedParking.length; i++) {
                  if(listOfBookedParking.elementAt(i).user_email==_usersModel.user_email){
                    bookingAction="Free Slot";
                  }
                  String _selected_row = listOfBookedParking.elementAt(i).selected_row;
                  String _row_col_name = listOfBookedParking.elementAt(i).row_col_name;
                  for (int j = 0; j < row_col_name_list.length; j++) {
                    if (_row_col_name == row_col_name_list.elementAt(j).row_col_name) {
                      if (_selected_row == this.row_select) {
                        row_col_name_list.elementAt(j).is_occupied = "occupied";
                      }
                    }
                  }
                }

                setState(() {});
              },
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Select Parking Slot',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.white),
            ],
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              height: MediaQuery.of(context).size.height / 2,
// Change as per your requirement
              // width: 300.0, // Change as per your requirement
              child:
                  // ListView.builder(
                  //     itemCount: no_of_col,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       String row_col_nameStr = row_col_name.elementAt(index);
                  // return GestureDetector(
                  //     child: buildRowList(context, index, row_col_nameStr),
                  //     onTap: () => {
                  //     setState(() {
                  //     selectedIndex = index;
                  //     })

                  GridView.count(
                shrinkWrap: true,
                childAspectRatio: 2 / 1.6,
                crossAxisCount: 3,
                children: List.generate(no_of_col, (index) {
                  String row_col_nameStr =
                      row_col_name_list.elementAt(index).row_col_name;
                  return Container(
                    color:
                        getColorSlot(index, row_col_name_list.elementAt(index)),
                    margin: EdgeInsets.all(7),
                    child: GestureDetector(
                      onTap: () {
                        // gotoNextScreen(rightsList.elementAt(index));
                        selectedIndex = index;

                        setState(() {});
                      },
                      child: Card(
                        elevation: 2,
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
                                  margin: EdgeInsets.all(10),
                                  width: 40,
                                  height: 40,
                                  child: Image.asset('assets/images/' +
                                      select_parking_type.toLowerCase() +
                                      '.png')),
                              Text(
                                row_select + "--" + row_col_nameStr,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                  );
                }),
              )
              // });
              // }),
              ),
          Divider(),
          Container(
            margin: const EdgeInsets.only(
              // top: 60.0,
              left: 50.0,
              right: 50.0,
            ),
            child: RaisedButton(
              color: getColor(enableSave),
              padding: EdgeInsets.all(15),
              onPressed: () {
                if(bookingAction=="Book Slot"){
                  bookSlotMethod();
                }else if(bookingAction=="Free Slot"){
                  freeSlot();
                }
              },
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  // "Book Slot",
                  bookingAction,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // buildRowList(BuildContext context, int index,
  //     String colStr) {
  //   return Card(
  //     color: selectedIndex == index ? Colors.blue : null,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //             margin: EdgeInsets.all(10),
  //             width: 50,
  //             height: 50,
  //             child: Image.asset('assets/images/parking_lot.png')),
  //         Text(
  //           colStr,
  //           style: TextStyle(
  //               fontSize: 17,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black,
  //               fontStyle: FontStyle.normal),
  //         ),
  //         Text(
  //           "Code: "+ row_select+ "--"+colStr,
  //           style: TextStyle(
  //               fontSize: 17,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black,
  //               fontStyle: FontStyle.normal),
  //         ),
  //
  //
  //       ],
  //     ),
  //   );
  // }

  saveAccountInfo() async {
    Map<String, String> parkingMap = {
      "parking_name": parking_name,
      "city": city,
      "address": address,
      "rows": rows,
    };

    await _dbHelper.saveParkingInfo(parkingMap);

    Map<String, String> parkingColMap = {};
    parkingColMap["parking_name"] = parking_name;

    // for (int i = 0; i < parking_row_list.length; i++) {
    //   parkingColMap[parking_row_list.elementAt(i).parking_row_name] =
    //       parking_row_list.elementAt(i).parking_col_num;
    // }
    await _dbHelper.saveParkingColumnInfo(parkingColMap);

    print(parkingColMap.length);
    print('check');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Added Successfully"),
    ));
    Navigator.pop(context);
  }

  Color getColor(bool color) {
    if (color == false) {
      return Colors.grey;
    } else if (color == true) {
      return Colors.green.shade200;
    } else {
      return Colors.yellowAccent.shade400;
    }
  }

  Color getColorSlot(int color, RowColValModel row_col) {
    // selectedIndex == index ? Colors.green : null
    if (row_col.is_occupied == "occupied") {
      return Colors.yellowAccent.shade400;
    } else if (color == selectedIndex) {
      return Colors.green;
    } else if (row_col.is_occupied == "unoccupied") {
      return Colors.white;
    }
  }

  addColDetail() async {
    parking_row_list.add(new ParkingRowModel(
        parking_name,
        ("R") + row_number.toString(),
        col_controllers.text.toString(),
        parkingDropdownVal));
    print(parking_row_list.length);
    col_controllers.clear();
    parkingDropdownVal = parking_type.first;
    setState(() {
      row_number += 1;
    });
  }

  getParkingInfo() async {
    QuerySnapshot parkingSnapshot =
        await FirebaseDBHelper().getParkingByName(_usersModel.location);
    for (int i = 0; i < parkingSnapshot.docs.length; i++) {
      parkingRowModel = new ParkingRowModel(
        parkingSnapshot.docs[i].data()["parking_name"],
        parkingSnapshot.docs[i].data()["city"],
        parkingSnapshot.docs[i].data()["address"],
        parkingSnapshot.docs[i].data()["rows"],
      );
    }
    // print(parkingRowModel.rows);
    for (int e = 0; e < int.parse(parkingRowModel.rows); e++) {
      row_names.add("R" + (e + 1).toString());
    }
    print(row_names.length);
    QuerySnapshot parkingColSnapshot =
        await FirebaseDBHelper().getParkingColumnByName(_usersModel.location);
    for (int i = 0; i < parkingColSnapshot.docs.length; i++) {
      try {
        String parking_name =
            await parkingColSnapshot.docs[i].data()["parking_name"];

        int row_no = int.parse(parkingRowModel.rows);
        for (int j = 0; j < row_no; j++) {
          no_of_col_in_row
              .add(parkingColSnapshot.docs[i].data()["R" + (j + 1).toString()]);
        }
      } catch (ex) {
      } finally {
        for (int i = 0; i < no_of_col_in_row.length; i++) {
          parkingRowCol_list.add(new ParkingRowColModel(_usersModel.location,
              "R" + (i + 1).toString(), no_of_col_in_row.elementAt(i)));
        }
        print(parkingRowCol_list.length);
      }

      //parking types

      QuerySnapshot parkingRowTypeSnapshot = await FirebaseDBHelper()
          .getParkingRowTypeByName(_usersModel.location);
      for (int i = 0; i < parkingRowTypeSnapshot.docs.length; i++) {
        try {
          String parking_name =
              await parkingRowTypeSnapshot.docs[i].data()["parking_name"];

          int row_no = int.parse(parkingRowModel.rows);
          for (int j = 0; j < row_no; j++) {
            row_no_type.add(parkingRowTypeSnapshot.docs[i]
                .data()["R" + (j + 1).toString()]);
          }
        } catch (ex) {
        } finally {
          for (int i = 0; i < no_of_col_in_row.length; i++) {
            parkingRowType_list.add(new ParkingRowTypeModel(
                _usersModel.location,
                "R" + (i + 1).toString(),
                row_no_type.elementAt(i)));
          }
          print(parkingRowType_list.length);
        }
      }
      // print(parkingRowModel.rows);

      listOfBookedParking.clear();
      QuerySnapshot parkingSnapshot =
          await FirebaseDBHelper().getBookingSlotByName(_usersModel.location);
      for (int i = 0; i < parkingSnapshot.docs.length; i++) {
        listOfBookedParking.add(new BookedParkingModel(
            parkingSnapshot.docs[i].data()["parking_name"],
            parkingSnapshot.docs[i].data()["selected_row"],
            parkingSnapshot.docs[i].data()["row_col_name"],
            parkingSnapshot.docs[i].data()["date_added"],
            parkingSnapshot.docs[i].data()["location"],
            parkingSnapshot.docs[i].data()["user_email"],
            parkingSnapshot.docs[i].data()["user_name"],
            parkingSnapshot.docs[i].data()["user_contact"]));
      }

      for (int i = 0; i < listOfBookedParking.length; i++) {
        if(listOfBookedParking.elementAt(i).user_email==_usersModel.user_email){
          bookingAction="Free Slot";
        }
        String _selected_row = listOfBookedParking.elementAt(i).selected_row;
        String _row_col_name = listOfBookedParking.elementAt(i).row_col_name;
        for (int j = 0; j < row_col_name_list.length; j++) {
          if (_row_col_name == row_col_name_list.elementAt(j).row_col_name) {
            if (_selected_row == this.row_select) {
              row_col_name_list.elementAt(j).is_occupied = "occupied";
            }
          }
        }
      }

      setState(() {});
    }
  }

  bookSlotMethod() async {
    Map<String, String> parkingMap = {
      "parking_name": _usersModel.location,
      "selected_row": row_select,
      "row_col_name": row_col_name_list[selectedIndex].row_col_name,
      "date_added": DateTime.now().toString().substring(0, 19),
      "location": _usersModel.location,
      "user_email": _usersModel.user_email,
      "user_name": _usersModel.user_name,
      "user_contact": _usersModel.user_contact,
    };

    await _dbHelper.saveBookingSlot(parkingMap);

    //////////////////////////////////////debit amount



    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      title: 'Slot Booked',
      desc:
          'You have booked this slot, 10 credit has been debited from your account',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
  }

  freeSlot() async {

    /////////////delete/////////////////

    QuerySnapshot usersSnapshot = await FirebaseDBHelper().getBookingSlotByName(_usersModel.location);
    for (int i = 0; i < usersSnapshot.docs.length; i++) {
      if (usersSnapshot.docs[i].data()["user_email"] == _usersModel.user_email) {
        final collection =
        FirebaseFirestore.instance.collection('booking_slot');
        collection
            .doc(usersSnapshot.docs[i].id) // <-- Doc ID to be deleted.
            .delete() // <-- Delete
            .then((_) => {print('Deleted')})
            .catchError((error) => print('Delete failed: $error'));
      }
    }

    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      title: 'Slot Free',
      desc:
      'You have unoccupied space',
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();

    /////////////delete/////////////////
  }
}

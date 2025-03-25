import 'package:carparking/data/FirebaseDBHelper.dart';
import 'package:carparking/ui/admin/models/ParkingRowModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddParking extends StatefulWidget {
  String header_title = "";
  String userEmail = "";
  String username = "";
  String user_contact, user_location;

  AddParking(this.header_title, this.userEmail, this.username,
      this.user_contact, this.user_location);

  @override
  _AddParkingState createState() => _AddParkingState(
      header_title, userEmail, username, user_contact, user_location);
}

class _AddParkingState extends State<AddParking> {
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
  TextEditingController col_controllers = new TextEditingController();
  List<String> parking_type = ['Car', 'Bike', 'Truck', 'Bus', 'Van'];
  List<ParkingRowModel> parking_row_list = [];
  int row_number = 1;
  String parkingDropdownVal;

  _AddParkingState(this.appBartitle, this.userEmail, this.username,
      this.user_contact, this.user_location);

  FirebaseDBHelper _dbHelper = new FirebaseDBHelper();

  @override
  Future<void> initState() {
    parkingDropdownVal = parking_type.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
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
                controller: parking_nameController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Parking name",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    parking_name = val;
                  } else {
                    parking_name = "";
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
                controller: cityController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "City",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    city = val;
                  } else {
                    city = "";
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
                controller: addressController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Address",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    address = val;
                  } else {
                    address = "";
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
                controller: rowsController,
                decoration: InputDecoration(
                    isDense: true,
                    labelText: "Number of Rows",
                    border: OutlineInputBorder()),
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    rows = val;
                  } else {
                    rows = "";
                  }
                }),
          ),
          addColumn && int.parse(rows) >= (parking_row_list.length + 1)
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Enter Number of Columns In each Row',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: TextFormField(
                                      textAlign: TextAlign.start,
                                      controller: col_controllers,
                                      validator: (val) {
                                        return val.length > 1
                                            ? null
                                            : "Give number of column";
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          labelText: "No. of Column in Row " +
                                              (row_number).toString(),
                                          border: OutlineInputBorder()),
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {},
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: parkingDropdownVal,
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
                                        parkingDropdownVal = newValue;
                                      });
                                    },
                                    items: parking_type
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                        left: 80.0,
                        right: 80.0,
                      ),
                      child: RaisedButton(
                        color: Colors.green,
                        padding: EdgeInsets.all(15),
                        onPressed: () async {
                          if (col_controllers.text.isNotEmpty) {
                            await addColDetail();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please provide number of columns"),
                            ));
                          }
                        },
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Add',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
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
                    'Row Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.white),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Row',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Columns',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Parking Type',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 200.0, // Change as per your requirement
            // width: 300.0, // Change as per your requirement
            child: ListView.builder(
                itemCount: parking_row_list.length,
                itemBuilder: (BuildContext context, int index) {
                  ParkingRowModel parkrow = parking_row_list.elementAt(index);
                  return GestureDetector(
                      child: buildRowList(context, index, parkrow),
                      onTap: () => {});
                }),
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.only(
              left: 50.0,
              right: 50.0,
            ),
            child: RaisedButton(
              color: getColor(enableSave),
              padding: EdgeInsets.all(15),
              onPressed: () {
                if (parking_name.isNotEmpty &&
                    city.isNotEmpty &&
                    address.isNotEmpty) {
                  if (rows != null && rows != "") {
                    if (int.parse(rows) > 0) {
                      print('add col');
                      addColumn = true;
                      setState(() {});
                    }
                    if(parking_row_list.length>=int.parse(rows)){
                      print(parking_row_list.length);
                      print(int.parse(rows));
                      print('can proceed');
                      saveParkingInfo();

                    }else{
                      print("cant prcoed");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Incomplete information"),
                      ));
                    }

                  } else {
                    print('in compete');
                  }
                } else {
                  print('incomplete info');

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Incomplete information"),
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
                  addColumn ? "Save" : "Next",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildRowList(
      BuildContext context, int index, ParkingRowModel parkingRowModel) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Text(
            parkingRowModel.parking_row_name,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.normal),
          ),
          Text(
            parkingRowModel.parking_col_num,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.normal),
          ),
          Text(
            parkingRowModel.parking_row_type,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.normal),
          ),
        ],
      ),
    );
  }

  saveParkingInfo() async {
    Map<String, String> parkingMap = {
      "parking_name": parking_name,
      "city": city,
      "address": address,
      "rows": rows,
    };

    await _dbHelper.saveParkingInfo(parkingMap);

    Map<String, String> parkingColMap = {};
    parkingColMap["parking_name"] = parking_name;

    for (int i = 0; i < parking_row_list.length; i++) {
      parkingColMap[parking_row_list.elementAt(i).parking_row_name] = parking_row_list.elementAt(i).parking_col_num;
    }
    await _dbHelper.saveParkingColumnInfo(parkingColMap);

    Map<String, String> parkingRowTypeMap = {};
    parkingRowTypeMap["parking_name"] = parking_name;

    for (int i = 0; i < parking_row_list.length; i++) {
      parkingRowTypeMap[parking_row_list.elementAt(i).parking_row_name] = parking_row_list.elementAt(i).parking_row_type;
    }
    await _dbHelper.saveParkingRowType(parkingRowTypeMap);


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
      return Colors.green;
    } else {
      return Colors.yellowAccent.shade400;
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
}

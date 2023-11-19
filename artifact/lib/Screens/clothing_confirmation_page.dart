import 'dart:convert';

import 'package:artifact/admin_home_page.dart';
import 'package:artifact/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:artifact/home_page.dart";

import 'package:http/http.dart' as http;

class ClothingConfirmationPage extends StatefulWidget {
  final List<dynamic> genders, ages, items, sizes, emergencies, notes;
  const ClothingConfirmationPage(
      {super.key,
      required this.genders,
      required this.ages,
      required this.items,
      required this.sizes,
      required this.emergencies,
      required this.notes});
  @override
  _ClothingConfirmationPageState createState() {
    return _ClothingConfirmationPageState();
  }
}

class _ClothingConfirmationPageState extends State<ClothingConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    return FutureBuilder(
        future: fetchUserInformation(context, uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String userName = snapshot.data['name'];
            String userAddress = snapshot.data['address'];
            String userPhoneNum = snapshot.data['phone'];
            String secondLine = snapshot.data['city'] +
                ', ' +
                snapshot.data['state'] +
                ', ' +
                snapshot.data['zip'];
            return Scaffold(
                bottomNavigationBar: Padding(
                    padding: EdgeInsets.only(
                        top: height * 1.0 / 32.0,
                        left: width * 1.0 / 5.0,
                        right: width * 1.0 / 5.0,
                        bottom: height * 1.0 / 32.0),
                    child: SizedBox(
                      child: CupertinoButton(
                        color: const Color(0xFF7EA5F4),
                        onPressed: () {
                          submitDB();
                          if (AppUser.isAdmin == PermissionStatus.admin) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return const AdminHomePage();
                            })));
                          } else {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return const HomePage();
                            })));
                          }
                        },
                        child: const Text(
                          "Submit Request",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                body: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    // appBar: AppBar(actions: [Actions(actions: <Widget>[]>, child: child)]),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(height: height * 1.0 / 18.0),
                      Row(
                        children: [
                          Stack(alignment: Alignment.topLeft, children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                    iconSize: width * 1.0 / 18.0,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.arrow_back))),
                          ]),
                          const Text(
                            "   Review Order",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: width * 1.0 / 6.0,
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero))),
                              onPressed: () {
                                if (AppUser.isAdmin == PermissionStatus.admin) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return const AdminHomePage();
                                  })));
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return const HomePage();
                                  })));
                                }
                              },
                              child: const Text("Cancel",
                                  style: TextStyle(color: Colors.red)))
                        ],
                      ),
                      SizedBox(height: height * 1.0 / 18.0),
                      Row(
                        children: [
                          SizedBox(width: width * 1.0 / 22.0),
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Color(0xFF808080),
                            size: 30,
                          ),
                          const Text(
                            "Items",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color(0xFF808080)),
                          ),
                        ],
                      ),
                      Flexible(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.items.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 1.0 / 12.0),
                                child: Card(
                                    elevation: 0,
                                    color: const Color(0xFFF4F4F4),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 1.0 / 35.0,
                                          top: height * 1.0 / 75.0,
                                          bottom: height * 1.0 / 75.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          width * 11.0 / 42.0)
                                                ],
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 1.0 / 12.0,
                                                vertical: height * 1.0 / 55.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Item: ${widget.items[index]}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF2E2E2E))),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          height * 1.0 / 130.0),
                                                  child: Text(
                                                      'Gender: ${widget.genders[index]}',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF2E2E2E),
                                                          fontSize: 14)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          height * 1.0 / 130.0),
                                                  child: Text(
                                                      'Age: ${widget.ages[index]}',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF2E2E2E),
                                                          fontSize: 14)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          height * 1.0 / 130.0),
                                                  child: Text(
                                                      'Size: ${widget.sizes[index]}',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF2E2E2E),
                                                          fontSize: 14)),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          height * 1.0 / 130.0),
                                                  child: Text(
                                                      'Other Notes: ${widget.notes[index]}',
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF2E2E2E),
                                                          fontSize: 14)),
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            }),
                      ),
                      SizedBox(
                        height: height * 1.0 / 24.0,
                      ),
                      Container(
                        height: 1.0,
                        width: width * 1.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: height * 1.0 / 32.0),
                      Row(
                        children: [
                          SizedBox(width: width * 1.0 / 22.0),
                          const Icon(
                            Icons.location_pin,
                            size: 30,
                            color: Color(0xFF808080),
                          ),
                          const Text(
                            "Address",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF808080)),
                          ),
                          SizedBox(width: width * 1.0 / 1.75),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 1.0 / 40.0,
                              horizontal: width * 1.0 / 28.0),
                          child: Text(userAddress),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 28.0),
                          child: Text(secondLine),
                        ),
                      ),
                      SizedBox(
                        height: height * 1.0 / 32.0,
                      ),
                      Container(
                        height: 1.0,
                        width: width * 1.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: height * 1.0 / 32.0),
                      Row(
                        children: [
                          SizedBox(width: width * 1.0 / 22.0),
                          const Icon(
                            Icons.person_outline,
                            color: Color(0xFF808080),
                            size: 30,
                          ),
                          const Text(
                            "Contact Information",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF808080)),
                          ),
                          SizedBox(width: width * 1.0 / 2.75),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 1.0 / 40.0,
                              horizontal: width * 1.0 / 28.0),
                          child: Text(userName),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 28.0),
                          child: Text(userPhoneNum),
                        ),
                      ),

                      // Padding(
                      //   padding: EdgeInsets.symmetric(vertical: height * 1.0 / 40.0),
                      //   child: Text("Number of User"),
                      // )
                    ])));
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Future submitDB() async {
    //print('submit clothing called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url = Uri.parse(
        'http://35.211.220.99/requests/clothing/create?requester=$uid');

    var id_url = Uri.parse('http://35.211.220.99/requestno?requester=$uid');

    if (uid == null || uid == "") {
      //print("failed: no current user");
      return;
    }
    for (var i = 0; i < widget.items.length; i++) {
      await http.get(id_url).then((value) async {
        //var a = json.decode(value.toString());
        //print(a);
        //print(value.body.toString());
        var requestNumber = value.body.toString().substring(
            value.body.toString().indexOf(':') + 1,
            value.body.toString().indexOf('}'));
        var postBody = <String, dynamic>{};
        postBody.addEntries([
          MapEntry('gender', widget.genders[i]),
          MapEntry('age', widget.ages[i]),
          MapEntry('item', widget.items[i]),
          MapEntry('size', widget.sizes[i]),
          MapEntry('emergency', widget.emergencies[i]),
          MapEntry('notes', widget.notes[i]),
          MapEntry('uid', uid),
          MapEntry('requestno', requestNumber)
        ]);
        var response = await http.post(url, body: postBody);
        // print('Response body: ${response.body}');
      });
    }
  }

  Future fetchUserInformation(BuildContext context, String uid) async {
    debugPrint('getting user information');
    var url = Uri.parse('http://35.211.220.99/users?id=$uid&requester=$uid');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    try {
      return data;
    } catch (e) {
      debugPrint('Could not fetch user data');
    }
  }
}

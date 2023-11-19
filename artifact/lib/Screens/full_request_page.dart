import 'dart:collection';

import 'package:artifact/Screens/admin_request_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class FullRequestPage extends StatefulWidget {
  final String requestno;
  const FullRequestPage({super.key, required this.requestno});

  @override
  _FullRequestPageState createState() {
    return _FullRequestPageState(requestno);
  }
}

class _FullRequestPageState extends State<FullRequestPage> {
  String requestno;
  _FullRequestPageState(this.requestno);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 14),
      child: FutureBuilder<List<String>>(
          future: Future.wait([getRequest(requestno), getUser(requestno)]),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              var request = json.decode(snapshot.data![0].toString());
              var user = json.decode(snapshot.data![1].toString());

              return MaterialApp(
                  theme: ThemeData(scaffoldBackgroundColor: Colors.white),
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                      body: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(children: [
                            SizedBox(height: height * 1.0 / 12.0),
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: IconButton(
                                      color: const Color(0xFF2E2E2E),
                                      iconSize: width * 1.0 / 18.0,
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: ((context) {
                                          return const AdminRequestPage();
                                        })));
                                      },
                                      icon: const Icon(Icons.arrow_back)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Request #" + request['requestno'],
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2E2E2E))),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Date Created: " + request['date'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF2E2E2E)),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(width: width / 8.0, height: 1),
                                        TextButton(
                                            onPressed: () {
                                              updateRequest(
                                                  requestno, 'denied');
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: ((context) {
                                                return const AdminRequestPage();
                                              })));
                                            },
                                            child: const Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "Deny",
                                                  style: TextStyle(
                                                      color: Color(0xFFC36551),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )))
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 1.0 / 17.0,
                                    vertical: height * 1.0 / 55.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.person_outline,
                                          color: Color(0xFF808080),
                                        ),
                                        Text("Contact Information",
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 1.0 / 16,
                                          top: height * 1.0 / 90.0),
                                      child: Text("Name: ${user['name']}",
                                          style: const TextStyle(
                                              color: Color(0xFF2E2E2E),
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 1.0 / 16,
                                          top: height * 1.0 / 130.0),
                                      child: Text("Phone: ${user['phone']}",
                                          style: const TextStyle(
                                              color: Color(0xFF2E2E2E),
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 1.0 / 16,
                                          top: height * 1.0 / 130.0),
                                      child: Text("Email: ${user['email']}",
                                          style: const TextStyle(
                                              color: Color(0xFF2E2E2E),
                                              fontSize: 14)),
                                    ),
                                  ],
                                )),
                            const Divider(
                                thickness: 1, color: Color(0xFFD5D5D5)),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 1.0 / 17.0,
                                    vertical: height * 1.0 / 55.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.location_pin,
                                          color: Color(0xFF808080),
                                        ),
                                        Text("Address",
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 1.0 / 16,
                                          top: height * 1.0 / 90.0),
                                      child: Text(user['address'],
                                          style: const TextStyle(
                                              color: Color(0xFF2E2E2E),
                                              fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width * 1.0 / 16,
                                          top: height * 1.0 / 130.0),
                                      child: Text(
                                          user['city'] +
                                              ", " +
                                              user['state'] +
                                              " " +
                                              user['zip'],
                                          style: const TextStyle(
                                              color: Color(0xFF2E2E2E),
                                              fontSize: 14)),
                                    ),
                                  ],
                                )),
                            const Divider(
                                thickness: 1, color: Color(0xFFD5D5D5)),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 1.0 / 17.0,
                                    vertical: height * 1.0 / 55.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Color(0xFF808080),
                                        ),
                                        Text("Items",
                                            style: TextStyle(
                                                color: Color(0xFF808080),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 1.0 / 40,
                                            top: height * 1.0 / 130.0),
                                        child: Card(
                                            color: const Color(0xFFF9F9F9),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * 1.0 / 35.0,
                                                    top: height * 1.0 / 75.0,
                                                    bottom:
                                                        height * 1.0 / 75.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "Item: " +
                                                                request['item'],
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                    0xFF2E2E2E))),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: height *
                                                                      1.0 /
                                                                      130.0),
                                                          child: Text(
                                                              "Gender: " +
                                                                  request[
                                                                      'gender'],
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF2E2E2E),
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: height *
                                                                      1.0 /
                                                                      130.0),
                                                          child: Text(
                                                              "Size: " +
                                                                  request[
                                                                      'size'],
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF2E2E2E),
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: height *
                                                                      1.0 /
                                                                      130.0),
                                                          child: Text(
                                                              "Notes: " +
                                                                  request[
                                                                      'notes'],
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF2E2E2E),
                                                                  fontSize:
                                                                      14)),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 1, width: 1),
                                                  ],
                                                ))))
                                  ],
                                )),
                            SizedBox(height: height / 20.0),
                            ElevatedButton(
                                onPressed: () {
                                  updateRequest(requestno, 'completed');
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return const AdminRequestPage();
                                  })));
                                },
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: Size(
                                      width * 11.0 / 42.0, height * 1.0 / 25.0),
                                  backgroundColor: const Color(0xFF7EA5F4),
                                  elevation: 0.0,
                                  shadowColor: Colors.transparent,
                                ),
                                child: const Text(
                                  "Complete Request",
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xFFF9F9F9)),
                                ))
                          ]))));
            } else if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          }),
    );
  }

  Future<String> getRequest(String requestno) async {
    debugPrint('get request called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url = Uri.parse(
        'http://35.211.220.99/requests?requestno=$requestno&requester=$uid');

    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.body;
  }

  Future<String> getUser(String requestno) async {
    debugPrint('get user called');
    final request = await getRequest(requestno);
    var uid_requester = FirebaseAuth.instance.currentUser!.uid;
    var decode = json.decode(request.toString());
    String uid = decode['uid'];
    var url = Uri.parse(
        'http://35.211.220.99/users?id=$uid&requester=$uid_requester');

    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.body;
  }

  void updateRequest(String requestno, String status) async {
    debugPrint('update request called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url = Uri.parse(
        'http://35.211.220.99/requests/update?requestno=$requestno&requester=$uid');

    var response = await http.put(url, body: {'status': status});
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }
}

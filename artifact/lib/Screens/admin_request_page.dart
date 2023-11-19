import "package:flutter/material.dart";
import "package:artifact/admin_home_page.dart";
import "package:artifact/Screens/full_request_page.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminRequestPage extends StatefulWidget {
  const AdminRequestPage({super.key});

  @override
  _AdminRequestPageState createState() {
    return _AdminRequestPageState();
  }
}

class _AdminRequestPageState extends State<AdminRequestPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData(backgroundColor: Color(0xFFf9f9f9)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFFF9F9F9),
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  SizedBox(height: height * 1.0 / 13.5),
                  Stack(alignment: Alignment.topLeft, children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            iconSize: width * 1.0 / 18.0,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return const AdminHomePage();
                              })));
                            },
                            icon: const Icon(Icons.arrow_back))),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          children: [
                            SizedBox(height: height * 1.0 / 100.0),
                            const Text('Orders',
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold))
                          ],
                        ))
                  ]),
                  const RequestWidget(),
                ]))));
  }
}

class RequestWidget extends StatefulWidget {
  const RequestWidget({super.key});

  @override
  _RequestWidgetState createState() {
    return _RequestWidgetState();
  }
}

class _RequestWidgetState extends State<RequestWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: const TextStyle(fontSize: 14),
      child: FutureBuilder<String>(
          future: parseRequests(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              List<dynamic> decode = json.decode(snapshot.data.toString());
              List<dynamic> remove = [];
              for (int i = 0; i < decode.length; i++) {
                if (decode[i]['status'] != "received") {
                  remove.add(decode[i]);
                }
              }
              for (int j = 0; j < remove.length; j++) {
                decode.remove(remove[j]);
              }
              return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: decode.length,
                  itemBuilder: (context, index) {
                    int reqNum = index + 1;
                    return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 1.0 / 12.0),
                        child: Card(
                          elevation: 0,
                          color: const Color(0xFFF9F9F9),
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xFFD9D9D9)),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16))),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 1.0 / 55.0),
                              child: Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Request #" +
                                                  decode[index]['requestno'],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2E2E2E)),
                                              textAlign: TextAlign.left),
                                          Text(
                                            '${decode[index]['date']}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF2E2E2E)),
                                            textAlign: TextAlign.start,
                                          )
                                        ],
                                      ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(width: width * 11.0 / 42.0)
                                          ])
                                    ]),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 1.0 / 12.0,
                                        vertical: height * 1.0 / 55.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("" + decode[index]['item'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2E2E2E)),
                                              textAlign: TextAlign.left),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text('Size: ',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xFF808080)),
                                                          textAlign:
                                                              TextAlign.left),
                                                      Text('Gender: ',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                                0xFF808080),
                                                          ),
                                                          textAlign:
                                                              TextAlign.left)
                                                    ]),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      decode[index]['size'],
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Color(
                                                              0xFF2E2E2E)),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                    Text(
                                                      decode[index]['gender'],
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Color(
                                                              0xFF2E2E2E)),
                                                      textAlign:
                                                          TextAlign.right,
                                                    )
                                                  ],
                                                )
                                              ])
                                        ])),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: ((context) {
                                        return FullRequestPage(
                                            requestno:
                                                '${decode[index]['requestno']}');
                                      })));
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Color(0xFFC4DBFE))),
                                    child: const Text('View Full Request',
                                        style: TextStyle(
                                            color: Color(0xFF2E2E2E))))
                              ])),
                        ));
                  });
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

  Future<String> parseRequests() async {
    debugPrint('parse requests called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url = Uri.parse('http://35.211.220.99/requests/list?requester=$uid');
    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.body;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:artifact/home_page.dart";
import 'package:artifact/admin_home_page.dart';
import 'package:artifact/app_user.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRequestsPage extends StatefulWidget {
  const UserRequestsPage({super.key});

  @override
  _UserRequestsPageState createState() {
    return _UserRequestsPageState();
  }
}

class _UserRequestsPageState extends State<UserRequestsPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color(0xFFF9F9F9),
            body: Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
                      SizedBox(height: height * 1.0 / 13.0),
                      Stack(alignment: Alignment.centerLeft, children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                iconSize: width * 1.0 / 18.0,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back))),
                        const Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Requests",
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ))
                      ]),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width / 10.0,
                            vertical: height * 1.0 / 55.0),
                        child: const Text(
                            "Please contact mamie@carriesclosetofga.org if you want to edit or cancel your requests.",
                            style: TextStyle(
                                fontSize: 13.5, color: Color(0xFF2E2E2E))),
                      ),
                      const RequestWidget(),
                    ])))));
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

    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return FutureBuilder<String>(
      future: parseRequests(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          List<dynamic> decode = json.decode(snapshot.data.toString());
          decode.removeWhere((element) => element['uid'] != uid);

          return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: decode.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // if you need this
                          side: BorderSide(color: Color(0xFFD9D9D9), width: 1),
                        ),
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
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          decode[index]['date'],
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
                                        // processedButton(context)
                                        if (decode[index]['status'] ==
                                            "received")
                                          processedButton(context)
                                        else if (decode[index]['status'] ==
                                            "completed")
                                          deliveredButton(context)
                                        else if (decode[index]['status'] ==
                                            "denied")
                                          deniedButton(context)
                                      ],
                                    )
                                  ]),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0,
                                      vertical: height * 1.0 / 55.0),
                                  child: Column(
                                    //single item
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "" + decode[index]['item'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2E2E2E)),
                                        textAlign: TextAlign.left,
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "Size: ",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF808080)),
                                                ),
                                                Text(
                                                  "Gender: ",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF808080)),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  decode[index]['size'],
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF2E2E2E)),
                                                ),
                                                Text(
                                                  decode[index]['gender'],
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xFF2E2E2E)),
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ],
                                  )),
                              /*
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0,
                                      vertical: height * 1.0 / 50.0),
                                  child: Row(children: [
                                    Text("Address: ",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      decode[index]['address'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF2E2E2E)),
                                    ),
                                  ])),
                              */
                              TextButton(
                                onPressed: () {
                                  deleteRequest(decode[index]['requestno']);
                                  if (AppUser.isAdmin ==
                                      PermissionStatus.admin) {
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
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  minimumSize: Size(
                                      width * 11.0 / 42.0, height * 1.0 / 25.0),
                                  backgroundColor: const Color(0xFFC4DBFE),
                                ),
                                child: const Text(
                                  'Delete Request',
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFF2E2E2E)),

                                  // if (decode[index]['status'] == "denied")
                                  //   TextButton(
                                  //     onPressed: () {
                                  //       // deleteRequest(decode[index]['requestno']);
                                  //       Navigator.push(context,
                                  //           MaterialPageRoute(builder: ((context) {
                                  //         // return HomePage();
                                  //         return const UserRequestsPage();
                                  //       })));
                                  //     },
                                  //     style: TextButton.styleFrom(
                                  //       shape: RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.circular(7)),
                                  //       minimumSize: Size(width * 11.0 / 42.0,
                                  //           height * 1.0 / 25.0),
                                  //       backgroundColor: const Color(0xFFC4DBFE),
                                  //     ),
                                  //     child: const Text(
                                  //       'Delete Request',
                                  //       style: TextStyle(
                                  //           fontSize: 12, color: Color(0xFF2E2E2E)),
                                  //     ),
                                ),
                              )
                            ])),
                      ),
                    );
                  }));
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
      },
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

  void deleteRequest(String requestno) async {
    debugPrint('delete request called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url = Uri.parse(
        'http://35.211.220.99/requests/remove?requestno=$requestno&requester=$uid');

    var response = await http.delete(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }
}

Widget processedButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return TextButton(
    onPressed: null,
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      minimumSize: Size(width * 11.0 / 42.0, height * 1.0 / 25.0),
      backgroundColor: const Color(0xFFFFF3C8),
    ),
    child: Text("PROCESSED",
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDCB631))),
  );
}

Widget deliveredButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return TextButton(
    onPressed: null,
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      minimumSize: Size(width * 11.0 / 42.0, height * 1.0 / 25.0),
      backgroundColor: const Color(0xFFE8F5E5),
    ),
    child: Text("DELIVERED",
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7EB871))),
  );
}

Widget deniedButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  return TextButton(
    onPressed: null,
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      minimumSize: Size(width * 11.0 / 42.0, height * 1.0 / 25.0),
      backgroundColor: const Color(0xFFF5E8E5),
    ),
    child: Text("DENIED",
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC36551))),
  );
}


  // void deleteRequest(String requestno) async {
  //   debugPrint('delete request called');
  //   bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  //   var url = isIOS
  //       ? Uri.parse(
  //           'http://127.0.0.1:8080/requests/remove?requestno=' + requestno)
  //       : Uri.parse(
  //           'http://10.0.2.2:8080/requests/remove?requestno=' + requestno);

  //   var response = await http.delete(url);
  //   debugPrint('Response status: ${response.statusCode}');
  //   debugPrint('Response body: ${response.body}');
  // }




// class _RequestWidgetState extends State<RequestWidget> {
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
//       child: Card(
//         child: Padding(
//             padding: EdgeInsets.symmetric(vertical: height * 1.0 / 55.0),
//             child: Column(children: [
//               Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Request #1",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2E2E2E)),
//                       textAlign: TextAlign.left,
//                     ),
//                     Text(
//                       "3/31/23",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontStyle: FontStyle.italic,
//                           color: Color(0xFF2E2E2E)),
//                       textAlign: TextAlign.start,
//                     )
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     TextButton(
//                       onPressed: null,
//                       style: TextButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(7)),
//                         minimumSize:
//                             Size(width * 11.0 / 42.0, height * 1.0 / 25.0),
//                         backgroundColor: const Color(0xFFFFF3C8),
//                       ),
//                       child: const Text("PROCESSED",
//                           style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFFDCB631))),
//                     ),
//                   ],
//                 )
//               ]),
//               Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: width * 1.0 / 12.0,
//                       vertical: height * 1.0 / 55.0),
//                   child: Column(
//                     //single item
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Item #: ",
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2E2E2E)),
//                         textAlign: TextAlign.left,
//                       ),
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: const [
//                                 Text(
//                                   "Size: ",
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       fontSize: 14, color: Color(0xFF808080)),
//                                 ),
//                                 Text(
//                                   "Gender: ",
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                       fontSize: 14, color: Color(0xFF808080)),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Text(
//                                   "*insert size*",
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                       fontSize: 14, color: Color(0xFF2E2E2E)),
//                                 ),
//                                 Text(
//                                   "*insert gender*",
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                       fontSize: 14, color: Color(0xFF2E2E2E)),
//                                 ),
//                               ],
//                             ),
//                           ]),
//                     ],
//                   )),
//               Padding(
//                   padding: EdgeInsets.symmetric(vertical: height * 1.0 / 50.0),
//                   child: Column(children: [
//                     Text(
//                       "Address ",
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2E2E2E)),
//                     ),
//                   ])),
//               TextButton(
//                 onPressed: null,
//                 style: TextButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(7)),
//                   minimumSize: Size(width * 11.0 / 42.0, height * 1.0 / 25.0),
//                   backgroundColor: const Color(0xFFC4DBFE),
//                 ),
//                 child: const Text(
//                   'Delete Request',
//                   style: TextStyle(fontSize: 12, color: Color(0xFF2E2E2E)),
//                 ),
//               ),
//             ])),
//       ),
//     );
//   }
// }


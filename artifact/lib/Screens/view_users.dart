import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import '../admin_home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});

  @override
  _ViewUsersPageState createState() {
    return _ViewUsersPageState();
  }
}

class _ViewUsersPageState extends State<ViewUsersPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
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
                  child: Column(children: [
                    SizedBox(height: height * 1.0 / 100.0),
                    const Text('Users',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold))
                  ]))
            ]),
            const ViewUsers(),
          ]),
        )));
  }
}

class ViewUsers extends StatefulWidget {
  const ViewUsers({super.key});

  @override
  _ViewUsersState createState() {
    return _ViewUsersState();
  }
}

class _ViewUsersState extends State<ViewUsers> {
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: parseUsers(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            List<dynamic> decode = json.decode(snapshot.data.toString());
            return ListView.builder(
                padding: const EdgeInsets.all(20.0),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: decode.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 0,
                      child: ListTile(
                          title: Text(decode[index]['name']),
                          subtitle: Text(decode[index]['email']),
                          visualDensity: const VisualDensity(
                              vertical: 1.0, horizontal: 0.25),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16))),
                          tileColor: const Color.fromRGBO(238, 224, 255, 1.0),
                          trailing: const Icon(Icons.more_vert),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return individualUserPage(context, decode, index);
                            })));
                          }));
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
        },
      ),
    );
  }

  Widget individualUserPage(
      BuildContext context, List<dynamic> decode, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //String user = decode[index];

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: Column(children: [
                  SizedBox(height: height * 1.0 / 18.0),
                  Stack(alignment: Alignment.topLeft, children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            iconSize: width * 1.0 / 18.0,
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return ViewUsersPage();
                              })));
                            },
                            icon: const Icon(Icons.arrow_back))),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset("assets/butterfly.png",
                            height: width * 1.0 / 2.25,
                            width: width * 1.0 / 2.25,
                            alignment: Alignment.center))
                  ]),
                  SizedBox(height: height * 1.0 / 48.0),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 20.0),
                      const Text('Name: ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['name'],
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 36.0),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 20.0),
                      const Text('Email Address:  ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['email'],
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 36.0),
                  Row(children: [
                    SizedBox(width: width * 1.0 / 20.0),
                    const Text('Phone Number:  ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ]),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['phone'],
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 36.0),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 20.0),
                      const Text('County Serving:  ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['county'],
                          style: TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 36.0),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 20.0),
                      const Text('Delivery Address:  ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['address'],
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 36.0),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 20.0),
                      const Text('City:  ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['city'],
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 36.0),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 20.0),
                      const Text('Zip Code:  ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['zip'],
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 36.0),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 20.0),
                      const Text('permissions:  ',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: width * 1.0 / 10.0),
                      Text(decode[index]['permissions'],
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(height: height * 1.0 / 18.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            makeAdmin(decode[index]['id']);
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return const ViewUsersPage();
                            })));
                          },
                          child: const Text('Make administrator'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            deleteUser(decode[index]['id']);
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return const ViewUsersPage();
                            })));
                          },
                          child: const Text('Delete'),
                        ),
                        const SizedBox(width: 8),
                      ])
                ]))));
  }

  Future<String> parseUsers() async {
    debugPrint('parse users called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url = Uri.parse('http://35.211.220.99/users/list?requester=$uid');

    var response = await http.get(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    return response.body;
  }

  void makeAdmin(String id) async {
    //need to implement logic of make admin button greyed out if they're alrdy admin
    debugPrint('make admin called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url =
        Uri.parse('http://35.211.220.99/users/update?id=$id&requester=$uid');

    var response = await http.put(url, body: {'permissions': 'true'});
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }

  void deleteUser(String id) async {
    debugPrint('delete user called');
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var url =
        Uri.parse('http://35.211.220.99/users/remove?id=$id&requester=$uid');

    var response = await http.delete(url);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }
}

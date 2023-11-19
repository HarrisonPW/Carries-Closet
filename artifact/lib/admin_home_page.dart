import 'package:artifact/Screens/admin_request_page.dart';
import 'package:artifact/Screens/user_request_page.dart';
import 'package:artifact/Screens/full_request_page.dart';
import 'package:artifact/Screens/multi_clothing_form_page.dart';
import 'package:artifact/Screens/multi_hygiene_form_page.dart';
import 'package:artifact/Screens/profile_page.dart';
import 'package:artifact/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:artifact/Screens/view_users.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.email;
    final String userEmail;
    userEmail = userId != null ? userId.toString() : "*****@gmail.com";
    const String dummyPassword = "********";
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Column(children: [
          SizedBox(height: height * 1.0 / 13.5),
          Row(textDirection: TextDirection.rtl, children: [
            SizedBox(width: width * 1.0 / 12.0),
            TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size(width * 1.0 / 5.0, height * 1.0 / 27.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color(0xFF7EA5F4)),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return const MainPage(isLogin: true);
                  })));
                },
                child: const Text('Logout',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF9F9F9))))
          ]),
          Image.asset("assets/logo.png",
              alignment: Alignment.topCenter,
              width: width * 2 / 2.5,
              height: width * 2 / 2.5),
          SizedBox(height: height * 1.0 / 20.0),
          TextButton(
              style: TextButton.styleFrom(
                  minimumSize: Size(width * 3.0 / 4.0, height * 1.0 / 14.0),
                  backgroundColor: const Color(0xFFEEE0FF),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => requestPopUp(context));
              },
              child: const Text('Submit a Request',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2E2E2E)))),
          SizedBox(height: height * 1.0 / 40.0),
          Row(
            children: [
              SizedBox(height: height * 1.0 / 40.0),
              Row(children: [
                SizedBox(width: width * 1.0 / 8.0),
                TextButton(
                    style: TextButton.styleFrom(
                        minimumSize:
                            Size(width * 11.0 / 32.0, height * 1.0 / 10.0),
                        backgroundColor: const Color(0xFFC4DBFE),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return const ViewUsersPage();
                      })));
                    },
                    child: const Text('View \nUsers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E2E2E)))),
                SizedBox(width: width * 1.0 / 16.0),
                TextButton(
                    style: TextButton.styleFrom(
                        minimumSize:
                            Size(width * 11.0 / 32.0, height * 1.0 / 10.0),
                        backgroundColor: const Color(0xFFC4DBFE),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return const UserRequestsPage();
                      })));
                    },
                    child: const Text('View \nRequests',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E2E2E)))),
              ])
            ],
          ),
          SizedBox(height: height * 1.0 / 40.0),
          TextButton(
              style: TextButton.styleFrom(
                  minimumSize: Size(width * 3.0 / 4.0, height * 1.0 / 14.0),
                  backgroundColor: const Color(0xFFC4DBFE),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return ProfileForm(email: userEmail, password: dummyPassword);
                })));
              },
              child: const Text('Edit Profile',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2E2E2E)))),
          SizedBox(height: height * 1.0 / 40.0),
          TextButton(
              style: TextButton.styleFrom(
                  minimumSize: Size(width * 3.0 / 4.0, height * 1.0 / 14.0),
                  backgroundColor: const Color(0xFFC4DBFE),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const AdminRequestPage();
                })));
              },
              child: const Text('View Orders',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF2E2E2E)))),
        ])));
  }

  Widget requestPopUp(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ButtonBarTheme(
        data: const ButtonBarThemeData(alignment: MainAxisAlignment.center),
        child: AlertDialog(
            // actionsAlignment: MainAxisAlignment.center,
            //title: const Text('Please select the type of request form:'),
            actions: <Widget>[
              SizedBox(height: height * 1.0 / 40.0),
              const Text('What type of item are you requesting?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: height * 1.0 / 40.0),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(width / 2.0, height * 1.0 / 17.0),
                    foregroundColor: const Color(0xFF2E2E2E),
                    backgroundColor: const Color(0xFFC4DBFE),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return MultiClothingFormWidget();
                    })));
                  },
                  child: const Text('Clothing Item',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: height * 1.0 / 40.0),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(width / 2.0, height * 1.0 / 17.0),
                      foregroundColor: const Color(0xFF2E2E2E),
                      backgroundColor: const Color(0xFFC4DBFE),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return MultiHygieneFormWidget();
                      })));
                    },
                    child: const Text('Hygiene Item',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ),
              SizedBox(height: height * 1.0 / 40.0)
            ]));
  }
}

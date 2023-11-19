import 'dart:convert';
import 'package:artifact/Screens/sign_up_page.dart';
import 'package:artifact/Screens/login_page.dart';
import 'package:artifact/admin_home_page.dart';
import 'package:artifact/admin_login.dart';
import 'package:artifact/home_page.dart';
import 'package:artifact/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:artifact/Screens/open_page.dart';
import 'package:http/http.dart' as http;

const AlignmentGeometry topcenter = Alignment.topCenter;
const AlignmentGeometry topleft = Alignment.topLeft;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OpenPage(),
  ));
}

class MainPage extends StatelessWidget {
  final bool isLogin;
  const MainPage({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
            AppUser user = AppUser();
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: checkPermissions(context, uid),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      user.setAdminStatus(PermissionStatus.admin);
                      return const AdminHomePage();
                    } else if (snapshot.data == false) {
                      user.setAdminStatus(PermissionStatus.user);
                      return const HomePage();
                    } else {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 1.3,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  });
            } else if (isLogin) {
              return const LoginPage();
            } else {
              return const SignUpPage();
            }
          },
        ),
      );
  Future checkPermissions(BuildContext context, String uid) async {
    var url = Uri.parse('http://35.211.220.99/users?id=$uid&requester=$uid');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    try {
      return data['permissions'] == 'true' ? true : false;
    } catch (e) {
      return false;
    }
  }
}

// import 'dart:html';
import 'dart:convert';

import 'package:artifact/Screens/open_page.dart';
import 'package:artifact/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../admin_home_page.dart';
import '../app_user.dart';

class ProfileForm extends StatefulWidget {
  final String email;
  final String password;
  const ProfileForm({super.key, required this.email, required this.password});

  @override
  ProfileFormState createState() {
    return ProfileFormState();
  }
}

class ProfileFormState extends State<ProfileForm> {
  static String userFullName = '';
  static String userEmail = '';
  static String userPhoneNum = '';
  static String userCounty = '';
  static String userAddress = '';
  static String userCity = '';
  static String userState = '';
  static String userZip = '';
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  static final nameController = TextEditingController(text: userFullName);
  static final emailController = TextEditingController(text: userEmail);
  static final phoneController = TextEditingController(text: userPhoneNum);
  static final countyController = TextEditingController(text: userCounty);
  static final addressController = TextEditingController(text: userAddress);
  static final cityController = TextEditingController(text: userCity);
  static final stateController = TextEditingController(text: userState);
  static final zipController = TextEditingController(text: userZip);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    countyController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (uid.isEmpty) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _profileFormKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        SizedBox(height: height * 1.0 / 18.0),
                        Stack(alignment: Alignment.topLeft, children: [
                          Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  iconSize: width * 1.0 / 18.0,
                                  onPressed: () {
                                    if (AppUser.isAdmin ==
                                        PermissionStatus.admin) {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: ((context) {
                                        return const AdminHomePage();
                                      })));
                                    } else if (AppUser.isAdmin ==
                                        PermissionStatus.user) {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: ((context) {
                                        return const HomePage();
                                      })));
                                    } else {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: ((context) {
                                        return const OpenPage();
                                      })));
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back))),
                        ]),
                        SizedBox(height: height * 1.0 / 32.0),
                        const Text("User Information",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32)),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0,
                              vertical: height * 1.0 / 36.0),
                          child: const Text(
                              "Please fill out information to edit the account",
                              textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0),
                          child: fullNameTextField(),
                        ),

                        SizedBox(height: height * 1.0 / 52.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0),
                          child: emailAddressTextField(),
                        ),
                        SizedBox(height: height * 1.0 / 52.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0),
                          child: phoneNumTextField(),
                        ),
                        SizedBox(height: height * 1.0 / 52.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0),
                          child: countyTextField(),
                        ),
                        SizedBox(height: height * 1.0 / 52.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0),
                          child: addressTextField(),
                        ),
                        SizedBox(height: height * 1.0 / 52.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0),
                          child: Row(
                            children: [
                              SizedBox(
                                // height: height *,
                                width: width * 1.0 / 2.0,
                                child: cityTextField(),
                              ),
                              SizedBox(width: width * 1.0 / 7.5),
                              SizedBox(
                                width: width * 1.0 / 5.0,
                                child: stateTextField(),
                              )
                            ],
                          ),
                        ), //City / State info

                        SizedBox(height: height * 1.0 / 52.0),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 1.0 / 12.0),
                          child: Row(
                            children: [
                              SizedBox(
                                // height: height *,
                                width: width * 1.0 / 2.0,
                                child: zipTextField(),
                              ),
                              SizedBox(width: width * 1.0 / 20.0),
                            ],
                          ),
                        ), //City / State info

                        SizedBox(height: height * 1.0 / 20.0),
                        TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minimumSize: Size(width / 2, height * 1.0 / 16),
                              backgroundColor: const Color(0xFF7EA5F4),
                            ),
                            onPressed: () {
                              if (_profileFormKey.currentState!.validate()) {
                                bool isIOS = Theme.of(context).platform ==
                                    TargetPlatform.iOS;
                                update_user_info(isIOS, context);
                              }
                            },
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF9F9F9)),
                            )),
                      ],
                    )
                  ]),
            ),
          ));
    } else {
      return FutureBuilder(
          future: fetchUserInformation(context, uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              userFullName = snapshot.data['name'];
              userEmail = snapshot.data['email'];
              userAddress = snapshot.data['address'];
              userCity = snapshot.data['city'];
              // It is supposed to be "county"
              userCounty = snapshot.data['county'];
              userPhoneNum = snapshot.data['phone'];
              userZip = snapshot.data['zip'];
              userState = snapshot.data['state'];
              return Scaffold(
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Form(
                      key: _profileFormKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                SizedBox(height: height * 1.0 / 18.0),
                                Stack(alignment: Alignment.topLeft, children: [
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: IconButton(
                                          iconSize: width * 1.0 / 18.0,
                                          onPressed: () {
                                            if (AppUser.isAdmin ==
                                                PermissionStatus.admin) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: ((context) {
                                                return const AdminHomePage();
                                              })));
                                            } else if (AppUser.isAdmin ==
                                                PermissionStatus.user) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: ((context) {
                                                return const HomePage();
                                              })));
                                            } else {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: ((context) {
                                                return const OpenPage();
                                              })));
                                            }
                                          },
                                          icon: const Icon(Icons.arrow_back))),
                                ]),
                                SizedBox(height: height * 1.0 / 32.0),
                                const Text("User Information",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32)),

                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0,
                                      vertical: height * 1.0 / 36.0),
                                  child: const Text(
                                      "Please fill out information to edit the account",
                                      textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0),
                                  child: fullNameTextField(),
                                ),

                                SizedBox(height: height * 1.0 / 52.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0),
                                  child: emailAddressTextField(),
                                ),
                                SizedBox(height: height * 1.0 / 52.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0),
                                  child: phoneNumTextField(),
                                ),
                                SizedBox(height: height * 1.0 / 52.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0),
                                  child: countyTextField(),
                                ),
                                SizedBox(height: height * 1.0 / 52.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0),
                                  child: addressTextField(),
                                ),
                                SizedBox(height: height * 1.0 / 52.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        // height: height *,
                                        width: width * 1.0 / 2.0,
                                        child: cityTextField(),
                                      ),
                                      SizedBox(width: width * 1.0 / 7.5),
                                      SizedBox(
                                        width: width * 1.0 / 5.0,
                                        child: stateTextField(),
                                      )
                                    ],
                                  ),
                                ), //City / State info

                                SizedBox(height: height * 1.0 / 52.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 1.0 / 12.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        // height: height *,
                                        width: width * 1.0 / 2.0,
                                        child: zipTextField(),
                                      ),
                                      SizedBox(width: width * 1.0 / 20.0),
                                    ],
                                  ),
                                ), //City / State info

                                SizedBox(height: height * 1.0 / 20.0),
                                TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      minimumSize:
                                          Size(width / 2, height * 1.0 / 16),
                                      backgroundColor: const Color(0xFF7EA5F4),
                                    ),
                                    onPressed: () {
                                      if (_profileFormKey.currentState!
                                          .validate()) {
                                        bool isIOS =
                                            Theme.of(context).platform ==
                                                TargetPlatform.iOS;
                                        update_user_info(isIOS, context);
                                      }
                                    },
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF9F9F9)),
                                    )),
                              ],
                            )
                          ]),
                    ),
                  ));
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

  Future signUp() async {
    debugPrint('signing up...');

    var credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: widget.email,
      password: widget.password,
    );
    debugPrint("uid: ${credential.user!.uid}");
    Uri url = Uri.parse('http://35.211.220.99/users/create');

    if (credential.user == null) {
      debugPrint("Failed.");
      return;
    }

    var response = await http.post(url, body: {
      'id': credential.user!.uid,
      'email': credential.user!.email,
      'permissions': 'false'
    });
    debugPrint("posted response");
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }

  Future update_user_info(bool isIOS, var context) async {
    if (FirebaseAuth.instance.currentUser == null) {
      await signUp();
    }
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid == "") {
      debugPrint("failed: no current user");
      return;
    }

    _profileFormKey.currentState?.save();

    Uri url =
        Uri.parse('http://35.211.220.99/users/update?id=$uid&requester=$uid');

    var response = await http.patch(url, body: {
      'name': ProfileFormState.nameController.text.trim(),
      //'lastName': ProfileFormState.lastNameController.text.trim(),
      //email would require special handling to change the firebase auth email, so ignoring for now
      'phone': ProfileFormState.phoneController.text.trim(),
      'county': ProfileFormState.countyController.text.trim(),
      'address': ProfileFormState.addressController.text.trim(),
      'city': ProfileFormState.cityController.text.trim(),
      'state': ProfileFormState.stateController.text.trim(),
      'zip': ProfileFormState.zipController.text.trim()
    });
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
    if (AppUser.isAdmin == PermissionStatus.admin) {
      Navigator.push(context, MaterialPageRoute(builder: ((context) {
        return const AdminHomePage();
      })));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: ((context) {
        return const HomePage();
      })));
    }
  }
}

Widget fullNameTextField() {
  return TextFormField(
    controller: ProfileFormState.nameController,
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF1F1F1),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
        borderRadius: BorderRadius.circular(10),
      ),
      labelText: "Full Name",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Name is Required";
      }
      return null;
    },
  );
}

Widget emailAddressTextField() {
  return TextFormField(
    controller: ProfileFormState.emailController,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Email Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Last Name is Required";
      }
      return null;
    },
  );
}

Widget phoneNumTextField() {
  return TextFormField(
    controller: ProfileFormState.phoneController,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Phone Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Phone Number is Required";
      }
      return null;
    },
  );
}

Widget countyTextField() {
  return TextFormField(
    controller: ProfileFormState.countyController,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "County Serving",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "County is Required";
      }
      return null;
    },
  );
}

Widget addressTextField() {
  return TextFormField(
    controller: ProfileFormState.addressController,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Delivery Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Address is Required";
      }
      return null;
    },
  );
}

Widget cityTextField() {
  return TextFormField(
    controller: ProfileFormState.cityController,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "City",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "City is Required";
      }
      return null;
    },
  );
}

Widget stateTextField() {
  return TextFormField(
    controller: ProfileFormState.stateController,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "State",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "State is Required";
      }
      return null;
    },
  );
}

Widget zipTextField() {
  return TextFormField(
    controller: ProfileFormState.zipController,
    decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF1F1F1),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: "Zip Code",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "Zip Code is Required";
      }
      return null;
    },
  );
}

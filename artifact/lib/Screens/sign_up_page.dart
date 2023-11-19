import 'package:artifact/Screens/open_page.dart';
import 'package:artifact/Screens/profile_page.dart';
import 'package:email_validator/email_validator.dart';
import "package:flutter/material.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reEnterController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Form(
                key: _signUpFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 1.0 / 18.0),
                    Stack(alignment: Alignment.topLeft, children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              iconSize: width * 1.0 / 18.0,
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: ((context) {
                                  return const OpenPage();
                                })));
                              },
                              icon: const Icon(Icons.arrow_back))),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Image.asset("assets/butterfly.png",
                              height: height * 1.0 / 3,
                              width: height * 1.0 / 3,
                              alignment: Alignment.bottomCenter))
                    ]),
                    //SizedBox(height: height * 1.0 / 13.5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Sign Up Now",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E2E2E))),
                        SizedBox(height: height * 1.0 / 90.0),
                        const Text(
                            "Enter an email and password to use for your account",
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF2E2E2E)))
                      ],
                    ),
                    SizedBox(height: height * 1.0 / 18.0),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Please enter a valid email'
                                : null,
                        controller: emailController,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F1F1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xFFF1F1F1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Email Address',
                          hintText: 'Enter your email',
                        ),
                      ),
                    ),
                    SizedBox(height: height * 1.0 / 25.0),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (password) =>
                            password != null && (password.length < 6)
                                ? 'Passwords must be at least 6 characters'
                                : null,
                        controller: passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F1F1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xFFF1F1F1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Password',
                          hintText: 'Enter your password',
                        ),
                      ),
                    ),
                    SizedBox(height: height * 1.0 / 25.0),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (reEnter) => reEnter != null &&
                                !(reEnter == passwordController.text.trim())
                            ? 'Passwords must match'
                            : null,
                        controller: reEnterController,
                        // textInputAction: TextInputAction.done,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F1F1),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Color(0xFFF1F1F1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your password',
                        ),
                      ),
                    ),
                    SizedBox(height: height * 1.0 / 20),
                    TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          minimumSize: Size(width / 1.5, height * 1.0 / 16),
                          backgroundColor: const Color(0xFF7EA5F4),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: goToProfilePage,
                      child: const Text('Create Account',
                          style: TextStyle(color: Color(0xFFF9F9F9))),
                    ),
                  ],
                )),
          ),
        ));
  }

  void goToProfilePage() {
    final isValidForm = _signUpFormKey.currentState!.validate();
    debugPrint('going to profile page');
    if (isValidForm) {
      String emailString = emailController.text.trim();
      String passwordString = passwordController.text.trim();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfileForm(email: emailString, password: passwordString)));
    }
    // dispose();
  }
}

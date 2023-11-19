import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Material(
        child: SingleChildScrollView(
            child: Column(children: [
      SizedBox(height: height * 1.0 / 18.0),
      Stack(alignment: Alignment.topLeft, children: [
        Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                iconSize: width * 1.0 / 18.0,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))),
        Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset("assets/dsdf1.png",
                height: height * 1.0 / 6.75,
                width: height * 1.0 / 6.75,
                alignment: Alignment.center))
      ]),
      SizedBox(height: height * 1.0 / 5.0),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 1.0 / 12.0),
        child: TextField(
          controller: emailController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xFFF1F1F1)),
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: 'Email Address',
            hintText: 'Enter your email address',
          ),
        ),
      ),
      SizedBox(height: height * 1.0 / 9.0),
      TextButton(
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: Size(width / 2, height * 1.0 / 16),
            backgroundColor: const Color(0xFF7EA5F4),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        onPressed: resetPassword,
        child: const Text('Reset Password',
            style: TextStyle(color: Color(0xFFF2F2F2))),
      ),
    ])));
  }

  Future resetPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
  }
}

import "package:flutter/material.dart";
import "package:artifact/main.dart";

class OpenPage extends StatefulWidget {
  const OpenPage({super.key});

  @override
  _OpenPageState createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        home: Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png",
                        alignment: Alignment.bottomCenter,
                        width: width * 3.0 / 4.0,
                        height: width * 3.0 / 4.0),
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          color: Color(0xFF2E2E2E),
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: height * 1.0 / 5.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minimumSize: Size(
                                    width * 1.25 / 2.0, height * 1.0 / 14.0),
                                //foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFF7EA5F4),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return MainPage(isLogin: isLogin);
                              })));
                            },
                            child: const Text("LOGIN",
                                style: TextStyle(color: Color(0xFFF9F9F9)))),
                        SizedBox(height: height * 1.0 / 23.0),
                        TextButton(
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minimumSize: Size(
                                    width * 1.25 / 2.0, height * 1.0 / 14.0),
                                //foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFFF1F1F1),
                                textStyle: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return MainPage(isLogin: !isLogin);
                              })));
                            },
                            child: const Text("SIGN UP",
                                style: TextStyle(color: Color(0xFF2E2E2E)))),
                      ],
                    )
                  ],
                ))));
  }
}

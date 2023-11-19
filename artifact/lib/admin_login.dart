import 'package:flutter/material.dart';


class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 100),

            Image.asset("assets/dsdf.png",
                height: 200, width: 200, alignment: Alignment.topCenter),

            const Padding(
              padding: EdgeInsets.only(left: 0, top: 0, right: 190, bottom: 0),
              child: Text(
                'Username',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 80, top: 4, right: 80, bottom: 30),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your username',
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 0, top: 0, right: 200, bottom: 0),
              child: Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 80, top: 4, right: 80, bottom: 30),
              child: TextField(
               obscureText: true,
               obscuringCharacter: '*',
               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                ),
              ),
            ),

            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromARGB(255, 200, 200, 200),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: 
                  ((context) {
                  return const AdminLogin();
                  })
                ));
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
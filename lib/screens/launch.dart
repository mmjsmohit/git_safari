import 'package:flutter/material.dart';
import 'package:instagram/api/client.dart';
import 'package:instagram/consts/constants.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/login.dart';
import 'package:instagram/screens/signup.dart';

import '../widgets/logo.dart';

class LaunchScreen extends StatelessWidget {
  LaunchScreen({Key? key}) : super(key: key);
  var _context;

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in.
    try {
      Future result = ApiClient.account.get();
      result.then((response) {
        // Logged in user
        Navigator.of(_context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }).catchError((error) {
        print(error.response);
      });
    } catch (error) {
      // User not logged in.
      print(error);
    }

    return MaterialApp(
      theme: kDarkTheme,
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        _context = context;
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GitSafariLogo(padding: EdgeInsets.all(16)),
              SizedBox(
                height: 40,
              ),
              GradientButton(
                icon: Icons.login,
                text: "Log In",
                onPressed: () async {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
              SizedBox(
                height: 16,
              ),
              GradientButton(
                icon: Icons.edit_note,
                text: "Sign Up",
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupScreen()));
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

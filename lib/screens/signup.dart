import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/login.dart';
import 'package:instagram/utils/appwrite/auth_api.dart';
import 'package:instagram/widgets/logo.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _email = TextEditingController();

  Future<void> signup() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircularProgressIndicator(),
                ]),
          );
        });
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      const snackbar = SnackBar(content: Text('Account created!'));
      await appwrite.createEmailSession(
        email: _email.text,
        password: _password.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    } on AppwriteException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.response['message']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60.0,
            ),
            GitSafariLogo(padding: EdgeInsets.all(16)),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
              child: TextField(
                controller: _name,
                style: TextStyle(fontSize: 14.0, color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Name',
                  hintStyle:
                      TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextField(
                controller: _username,
                style: TextStyle(fontSize: 14.0, color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Username',
                  hintStyle:
                      TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
              child: TextField(
                controller: _password,
                obscureText: true,
                style: TextStyle(fontSize: 14.0, color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Password',
                  hintStyle:
                      TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
              child: TextField(
                controller: _confirm,
                obscureText: true,
                style: TextStyle(fontSize: 14.0, color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Confirm Password',
                  hintStyle:
                      TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                controller: _email,
                style: TextStyle(fontSize: 14.0, color: Color(0xFFFFFFFF)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0x33FFFFFF), width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: 'Email',
                  hintStyle:
                      TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF)),
                ),
              ),
            ),
            GradientButton(
              text: 'Sign Up',
              icon: Icons.edit_note,
              onPressed: () => signup(),
            ),
            Container(
              height: 60.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 0.5,
                      color: Color(0x99FFFFFF),
                    ),
                  ),
                ),
                Text("OR",
                    style: TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF))),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 0.5,
                      color: Color(0x99FFFFFF),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    children: [
                      Text(
                        "Have an account?",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Color(0x99FFFFFF)),
                      ),
                      TextButton(
                        child: Text("Log In."),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
            Container(
              height: 60.0,
            ),
            Container(
              height: 0.5,
              color: Color(0x99FFFFFF),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                "Made by Mohit and Shaunak. Open source Rocks.",
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 12.0, color: Color(0x99FFFFFF)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

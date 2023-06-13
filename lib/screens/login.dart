import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:gitsafari/main.dart';
import 'package:gitsafari/screens/signup.dart';
import 'package:gitsafari/utils/appwrite/auth_api.dart';
import 'package:gitsafari/utils/isar/isar_service.dart';
import 'package:gitsafari/utils/isar/user_isar_collection.dart';
import 'package:gitsafari/widgets/buttons.dart';
import 'package:gitsafari/widgets/logo.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  // void login(BuildContext context) {
  //   // Attempt to login with email and password
  //   Future result = ApiClient.account.createEmailSession(
  //     email: _email.text,
  //     password: _password.text,
  //   );
  //   result.then((response) {
  //     // Success
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => HomeScreen(),
  //       ),
  //     );
  //   }).catchError((error) {
  //     // Failure
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Colors.red,
  //         content:
  //             Text('Following error has occured: ${error.response['message']}'),
  //       ),
  //     );
  //     print(error.response);
  //   });
  // }
  signIn() async {
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      final IsarService isar = context.read<IsarService>();
      await appwrite.createEmailSession(
        email: _email.text,
        password: _password.text,
      );
      final user = appwrite.currentUser;
      final newUserCollection = UserIsarCollection()
        ..email = _email.text
        ..username = user.$id
        ..name = user.name;
      isar.saveUser(newUserCollection);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LaunchScreen(),
          ));
    } on AppwriteException catch (error) {
      // Navigator.pop(context);
      print(error.response['message']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.response['message']),
        backgroundColor: Colors.red,
      ));
    }
  }

  signInWithProvider(String provider) async {
    try {
      await context.read<AuthAPI>().signInWithProvider(provider: provider);
    } on AppwriteException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.response['message']),
        backgroundColor: Colors.red,
      ));
    }
  }

  updateDb() {
    final AuthAPI appwrite = context.read<AuthAPI>();
    final IsarService isar = context.read<IsarService>();
    final user = appwrite.currentUser;
    final newUserCollection = UserIsarCollection()
      ..email = _email.text
      ..username = user.$id
      ..name = user.name;
    isar.saveUser(newUserCollection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 90.0,
            ),
            GitSafariLogo(padding: EdgeInsets.all(16)),
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
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
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0, top: 20.0, bottom: 30.0),
                  child: Text(
                    "Forgot password?",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF3797EF)),
                  ),
                ),
              ],
            ),
            GradientButton(
              width: 150,
              text: 'Log In',
              icon: Icons.login,
              onPressed: () => signIn(),
            ),
            SizedBox(
              height: 20,
            ),
            GradientSvgButton(
              text: 'Login with GitHub',
              imagePath: 'assets/icons/github/github-original.svg',
              onPressed: () {
                signInWithProvider('github');
                updateDb();
              },
              color: Colors.white,
            ),
            Container(
              height: 90.0,
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
                        "Don't have an account? ",
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Color(0x99FFFFFF)),
                      ),
                      TextButton(
                        child: Text("Sign up."),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
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
              height: 90.0,
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

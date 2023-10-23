import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
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

  // Handles the sign-in process.
  Future<void> _signIn() async {
    try {
      final appwrite = context.read<AuthAPI>();
      final isar = context.read<IsarService>();

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
      
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LaunchScreen(),
          ));
    } on AppwriteException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.response['message']),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Handles sign-in with external providers like GitHub.
  Future<void> _signInWithProvider(String provider) async {
    try {
      await context.read<AuthAPI>().signInWithProvider(provider: provider);
      final appwrite = context.read<AuthAPI>();
      Preferences result = await appwrite.account.getPrefs();

      if (result.data['bio'].toString() == null) {
        await appwrite.account.updatePrefs(prefs: {"bio": ""});
      }
      _updateDatabase();
    } on AppwriteException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.response['message']),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Updates the local database with user details.
  void _updateDatabase() {
    final appwrite = context.read<AuthAPI>();
    final isar = context.read<IsarService>();
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
      appBar: AppBar(backgroundColor: Colors.black),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 90.0),
            _buildLogo(),
            _buildEmailField(),
            _buildPasswordField(),
            _buildForgotPassword(),
            _buildLoginButton(),
            _buildGithubLoginButton(),
            Spacer(),
            _buildSignUpOption(),
            SizedBox(height: 90.0),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() => GitSafariLogo(padding: EdgeInsets.all(16));

  Widget _buildEmailField() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
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
            hintText: 'Email',
            hintStyle: TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF)),
          ),
        ),
      );

  Widget _buildPasswordField() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
            hintText: 'Password',
            hintStyle: TextStyle(fontSize: 14.0, color: Color(0x99FFFFFF)),
          ),
        ),
      );

  Widget _buildForgotPassword() => Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 16.0, top: 20.0, bottom: 30.0),
          child: Text(
            "Forgot password?",
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12.0, color: Color(0xFF3797EF)),
          ),
        ),
      );

  Widget _buildLoginButton() => GradientButton(
        width: 150,
        text: 'Log In',
        icon: Icons.login,
        onPressed: _signIn,
      );

  Widget _buildGithubLoginButton() => GradientSvgButton(
        text: 'Login with GitHub',
        imagePath: 'assets/icons/github/github-original.svg',
        onPressed: () {
          _signInWithProvider('github');
          _updateDatabase();
        },
        color: Colors.white,
      );

  Widget _buildSignUpOption() => Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Row(
          children: [
            Spacer(),
            Text(
              "Don't have an account? ",
              style: TextStyle(color: Color(0x99FFFFFF)),
            ),
            TextButton(
              child: Text("Sign up."),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupScreen(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      );

  Widget _buildFooter() => Column(
        children: [
          Divider(color: Color(0x99FFFFFF)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Made by Mohit and Shaunak. Open source Rocks.",
              style: TextStyle(fontSize: 12.0, color: Color(0x99FFFFFF)),
            ),
          ),
        ],
      );
}

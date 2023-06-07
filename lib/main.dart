import 'package:flutter/material.dart';
import 'package:instagram/screens/home.dart';
import 'package:instagram/screens/login.dart';
import 'package:instagram/utils/appwrite/auth_api.dart';
import 'package:provider/provider.dart';

import 'consts/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthAPI(),
      child: LaunchScreen(),
    ),
  );
  // runApp(LaunchScreen());
}

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final value = context.watch<AuthAPI>().status;
    print("TOP CHANGE NOTIFIER PROVIDER: $value");
    // Check if the user is logged in.

    return MaterialApp(
      theme: kDarkTheme,
      debugShowCheckedModeBanner: false,
      home: value == AuthStatus.uninitialized
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : value == AuthStatus.authenticated
              ? HomeScreen()
              : LoginScreen(),
      // Builder(builder: (context) {
      //       _context = context;
      //       return Scaffold(
      //         body: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             GitSafariLogo(padding: EdgeInsets.all(16)),
      //             SizedBox(
      //               height: 40,
      //             ),
      //             GradientButton(
      //               icon: Icons.login,
      //               text: "Log In",
      //               onPressed: () async {
      //                 Navigator.of(context).push(MaterialPageRoute(
      //                     builder: (context) => LoginScreen()));
      //               },
      //             ),
      //             SizedBox(
      //               height: 16,
      //             ),
      //             GradientButton(
      //               icon: Icons.edit_note,
      //               text: "Sign Up",
      //               onPressed: () {
      //                 Navigator.of(context).push(MaterialPageRoute(
      //                     builder: (context) => SignupScreen()));
      //               },
      //             ),
      //           ],
      //         ),
      //       );
      //     }),
    );
  }
}

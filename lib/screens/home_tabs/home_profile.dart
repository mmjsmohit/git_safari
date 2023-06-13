import 'package:flutter/material.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:gitsafari/main.dart';
import 'package:gitsafari/utils/appwrite/auth_api.dart';
import 'package:gitsafari/utils/appwrite/avatar_api.dart';
import 'package:gitsafari/utils/isar/isar_service.dart';
import 'package:provider/provider.dart';

class HomeProfileTab extends StatefulWidget {
  const HomeProfileTab({Key? key}) : super(key: key);

  @override
  State<HomeProfileTab> createState() => _HomeProfileTabState();
}

class _HomeProfileTabState extends State<HomeProfileTab> {
  final AvatarAPI avatars = AvatarAPI();

  final TextEditingController _bioController = TextEditingController();

  signOut() async {
    final AuthAPI appwrite = context.read<AuthAPI>();
    print("User Logged out!");
    await appwrite.signOut();
    await updateDb();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LaunchScreen(),
        ));
  }

  updateDb() async {
    final IsarService isar = IsarService();
    await isar.deleteUser();
  }

  // void setUser() async {
  //   final existingUser = await isar.getUser();
  //   print(existingUser.toString());
  //   _username = existingUser!.username!;
  //   _name = existingUser.name!;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFF121212),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 45.0,
              child: Row(
                children: [
                  Spacer(),
                  Image.asset(
                    "assets/private_icon.png",
                    width: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: FutureBuilder(
                      future: context.read<IsarService>().getUser(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? CircularProgressIndicator()
                            : Text(
                                snapshot.data!.name!,
                                style: TextStyle(color: Colors.white),
                              );
                      },
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 5, 5),
                    child: FutureBuilder(
                      future: avatars.getCurrentAvatar(),
                      //works for both public file and private file, for private files you need to be logged in
                      builder: (context, snapshot) {
                        Widget child = snapshot.hasData && snapshot.data != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.memory(
                                  height: 100,
                                  snapshot.data!,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 50,
                                child: CircularProgressIndicator(),
                              );
                        return AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          child: child,
                        );
                      },
                      // child: Image.asset(
                      //   "assets/profile.png",
                      //   width: 86.0,
                      //   fit: BoxFit.fill,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 16.0),
              child: FutureBuilder(
                future: context.read<IsarService>().getUser(),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? CircularProgressIndicator()
                      : Text(
                          snapshot.data!.username!,
                          style: TextStyle(color: Colors.white),
                        );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: FutureBuilder(
                  future: context.read<AuthAPI>().account.getPrefs(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 10,
                        );
                      } else {
                        return Text(
                          snapshot.data?.data['bio'],
                          style: TextStyle(
                              color: Color(0xFFF9F9F9), fontSize: 14.0),
                        );
                      }
                    } else {
                      return Text(
                        'No bio found. Enter a bio by clicking below!',
                        style:
                            TextStyle(color: Color(0xFFF9F9F9), fontSize: 14.0),
                      );
                    }
                  }
                  // snapshot.connectionState ==
                  //         ConnectionState.waiting
                  //     ? SizedBox(
                  //         height: 10,
                  //       )
                  //     : Text(
                  //         snapshot.data?.data['bio'],
                  //         style:
                  //             TextStyle(color: Color(0xFFF9F9F9), fontSize: 14.0),
                  //       ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      side: BorderSide(
                        color: Color(0x27FFFFFF),
                        width: 1.0,
                      ),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Color(0xFF121212),
                        title: const Text(
                          'Edit your bio',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: TextField(
                            cursorColor: Colors.white,
                            controller: _bioController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: "Bio",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            style: TextStyle(color: Colors.white)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AuthAPI>().account.updatePrefs(
                                  prefs: {"bio": _bioController.text});

                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    child: Text(
                      "Edit your bio",
                      style: TextStyle(
                        color: Color(0xFFF9F9F9),
                        fontSize: 13.0,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      side: BorderSide(
                        color: Color(0x27FFFFFF),
                        width: 1.0,
                      ),
                    ),
                    onPressed: () async {
                      await signOut();
                    },
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Color(0xFFF9F9F9),
                        fontSize: 13.0,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff111625)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'About ',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Image.asset(
                          "assets/logo/gs_logo.png",
                          width: 40,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 300,
                      child: SingleChildScrollView(
                        child: Text(
                          textAlign: TextAlign.center,
                          kGitSafariDescription,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

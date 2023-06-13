import 'package:flutter/material.dart';
import 'package:gitsafari/main.dart';
import 'package:gitsafari/utils/appwrite/auth_api.dart';
import 'package:gitsafari/utils/appwrite/avatar_api.dart';
import 'package:gitsafari/utils/isar/isar_service.dart';
import 'package:gitsafari/widgets/story.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Image.asset(
                    "assets/accounts_list.png",
                    width: 7.0,
                  ),
                  Spacer(),
                ],
              ),
            ),
            SizedBox(
              height: 100.0,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 5, 5, 5),
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
                  Expanded(
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          "54",
                          style: TextStyle(
                            color: Color(0xFFF9F9F9),
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "Posts",
                          style: TextStyle(
                            color: Color(0xFFF9F9F9),
                            fontSize: 13.0,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          "834",
                          style: TextStyle(
                            color: Color(0xFFF9F9F9),
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(
                            color: Color(0xFFF9F9F9),
                            fontSize: 13.0,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          "162",
                          style: TextStyle(
                            color: Color(0xFFF9F9F9),
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          "Following",
                          style: TextStyle(
                            color: Color(0xFFF9F9F9),
                            fontSize: 13.0,
                          ),
                        ),
                        Spacer(),
                      ],
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            SizedBox(
              height: 100.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10.0),
                    child: Column(
                      children: [
                        Container(
                          height: 62.0,
                          width: 62.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Color(0x14FFFFFF), width: 1.0),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/add_story.png",
                              width: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                          child: Center(
                            child: Text(
                              "New",
                              style: TextStyle(
                                color: Color(0xFFF9F9F9),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  StoryWidget(
                    image: Image.asset(
                      "assets/profile_story_1.png",
                      width: 56.0,
                    ),
                    name: "Friends",
                    seen: true,
                  ),
                  StoryWidget(
                    image: Image.asset(
                      "assets/profile_story_2.png",
                      width: 56.0,
                    ),
                    name: "Sports",
                    seen: true,
                  ),
                  StoryWidget(
                    image: Image.asset(
                      "assets/profile_story_3.png",
                      width: 56.0,
                    ),
                    name: "Design",
                    seen: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

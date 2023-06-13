import 'package:flutter/material.dart';
import 'package:gitsafari/screens/add_story.dart';
import 'package:gitsafari/screens/home_tabs/home_home.dart';
import 'package:gitsafari/screens/home_tabs/home_newpost.dart';
import 'package:gitsafari/screens/home_tabs/home_profile.dart';
import 'package:gitsafari/screens/home_tabs/home_search.dart';
import 'package:gitsafari/utils/appwrite/avatar_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _currentIndex = 0;
  final AvatarAPI avatars = AvatarAPI();
  List<Widget> tabs = [
    HomeHomeTab(),
    HomeSearchTab(),
    HomeNewpostTab(),
    AddStory(),
    HomeProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 22.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Color(0xFF121212),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: "home",
            icon: Image.asset(
              (_currentIndex == 0)
                  ? "assets/nav_home_s.png"
                  : 'assets/nav_home.png',
              width: 22.0,
            ),
          ),
          BottomNavigationBarItem(
            label: "reel",
            icon: Image.asset(
              'assets/nav_reel.png',
              width: 22.0,
            ),
          ),
          BottomNavigationBarItem(
            label: "profile",
            icon: FutureBuilder(
              future: avatars.getCurrentAvatar(),
              //works for both public file and private file, for private files you need to be logged in
              builder: (context, snapshot) {
                Widget child = snapshot.hasData && snapshot.data != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          height: 26,
                          snapshot.data!,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 8,
                          child: CircularProgressIndicator(),
                        ),
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

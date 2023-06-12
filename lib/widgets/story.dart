import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StoryWidget extends StatelessWidget {
  Image image;
  String name;
  bool seen;

  StoryWidget(
      {Key? key, required this.image, required this.name, required this.seen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    (seen)
                        ? "assets/story_wrap_seen.png"
                        : "assets/story_wrap.png",
                    width: 62.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(child: image),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
            child: Center(
              child: Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class StoryWid extends StatelessWidget {
  final String username;
  const StoryWid({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: Color(0xff111625),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            child: Image.asset("assets/profile_2.png"),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              username,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

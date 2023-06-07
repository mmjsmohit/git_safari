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
  const StoryWid({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        shadowColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        color: Colors.grey.shade700,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(0, 56, 53, 53),
                  Color.fromARGB(126, 70, 62, 62),
                  Color.fromARGB(255, 55, 112, 86),
                  Color.fromARGB(193, 18, 183, 100)
                ],
              ),
            ),
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
                    "hello_there",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

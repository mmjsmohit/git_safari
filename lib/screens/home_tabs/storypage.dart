import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:story/story_image.dart';
import 'package:story/story_page_view.dart';

class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);

  final String stories;
  final String userName;
  final String imageUrl;
}

class Pair<String1, String2> {
  final String username;
  final String image_id;

  Pair(this.username, this.image_id);
}

class StoryPage extends StatefulWidget {
  final List<UserModel> sampleuser;
  final List<Pair> storymap;
  final List<String> users;

  const StoryPage(
      {Key? key,
      required this.sampleuser,
      required this.storymap,
      required this.users})
      : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;

  @override
  void initState() {
    super.initState();
    indicatorAnimationController = ValueNotifier<IndicatorAnimationCommand>(
        IndicatorAnimationCommand.resume);
  }

  @override
  void dispose() {
    indicatorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StoryPageView(
          itemBuilder: (context, pageIndex, storyIndex) {
            final user = widget.sampleuser[pageIndex];
            final story = user.stories[storyIndex];
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black),
                ),
                Positioned.fill(
                  child: StoryImage(
                    key: ValueKey(story),
                    imageProvider: CachedNetworkImageProvider(
                        '${APPWRITE_URL}/storage/buckets/6481a1c504e251c5d4b0/files/${user.stories}/view?project=$APPWRITE_PROJECT_ID&mode=admin'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 44, left: 8),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 20),
                  child: Text(
                    "Tap on the left side of the screen to begin story timer",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            );
          },
          gestureItemBuilder: (context, pageIndex, storyIndex) {
            return Stack(children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ]);
          },
          indicatorAnimationController: indicatorAnimationController,
          initialStoryIndex: (pageIndex) {
            if (pageIndex == 0) {
              return 1;
            }
            return 0;
          },
          pageLength: widget.sampleuser.length,
          storyLength: (int pageIndex) {
            return 1;
          },
          onPageLimitReached: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:gitsafari/consts/constants.dart';
import 'package:flutter/material.dart';
import 'package:gitsafari/api/client.dart';
import 'package:gitsafari/models/post_model.dart';
import 'package:gitsafari/widgets/post.dart';
import 'package:gitsafari/widgets/story.dart';
import 'package:intl/intl.dart';
import 'package:story/story_image.dart';
import 'package:story/story_page_view.dart';

class HomeHomeTab extends StatefulWidget {
  const HomeHomeTab({Key? key}) : super(key: key);

  @override
  _HomeHomeTab createState() => _HomeHomeTab();
}

class Pair<String1, String2> {
  final String username;
  final String image_id;

  Pair(this.username, this.image_id);
}

class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);

  final String stories;
  final String userName;
  final String imageUrl;
}

List<Pair> _storymap = [];
List<String> users = [];
List<UserModel> _sampleuser = [];

class _HomeHomeTab extends State<HomeHomeTab> {
  String _username = "";

  var subscription;
  var storysubscription;

  List<Post> _posts = [
    Post(
        date: DateFormat.yMMMEd().format(DateTime.now()),
        lang: 'dart',
        previewImageURL: "",
        githubURL: 'https://github.com/foss42/api-dash',
        image: "assets/profile_4.png",
        name: "joshua_l",
        location: "Tokyo, Japan",
        post: "assets/dpost.png",
        caption:
            "joshua_l The game in Japan was amazing and I want to share some photos",
        // date: DateTime.now(),
        liked: false),
  ];

  void likePost(BuildContext context, int i) {
    List<Post> newPosts = List.from(_posts);

    newPosts[i].liked = !newPosts[i].liked;
    if (newPosts[i].liked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You have liked this post."),
        ),
      );
    }
    setState(() {
      _posts = List.from(newPosts);
    });
  }

  void updateStoryList() {
    _sampleuser = [];
    _storymap = [];
    users = [];
    Future result = ApiClient.databases.listDocuments(
        databaseId: "6481a01aac2dfa64e4f8",
        collectionId: "6481a107205097a5ab41");

    result.then((response) {
      List docs = response.documents;
      print(docs);
      for (int i = 0; i < docs.length; ++i) {
        setState(() {
          users.add(docs[i].data["username"]);
          _storymap
              .add(Pair(docs[i].data["username"], docs[i].data["image-id"]));
        });
      }
      users.toSet().toList();
      _storymap.forEach((value) {
        _sampleuser.add(UserModel(value.image_id, value.username,
            "https://images.unsplash.com/photo-1609262772830-0decc49ec18c?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMDF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"));
      });
    });
  }

  void updateList() {
    _posts = [];

    // Get the list of documents (posts).
    Future result = ApiClient.databases.listDocuments(
      databaseId: APPWRITE_DATABASE_ID,
      collectionId: POST_COLLECTION_ID,
    );

    result.then((response) {
      List docs = response.documents;

      for (int i = docs.length - 1; i >= 0; i--) {
        // Assign a random profile pic to each post.
        int profileId = (i % 4) + 1;

        setState(() {
          print(docs[i].data);
          _posts.add(Post(
            date: docs[i].data['\$createdAt'],
            previewImageURL: docs[i].data["previewImageURL"],
            githubURL: docs[i].data["githubURL"],
            name: docs[i].data["username"],
            caption: docs[i].data["caption"],
            post: docs[i].data["imageId"],
            image: "assets/profile_$profileId.png",
            lang: docs[i].data["lang"],
          ));
        });
      }
    }).catchError((error) {
      // Error
      print(error.response);
    });
  }

  @override
  void initState() {
    super.initState();

    // Get the currently logged in account.
    Future result = ApiClient.account.get();

    result.then((response) {
      // Success
      setState(() {
        // Set the username fetched from account.
        _username = response.name;
      });
    }).catchError((error) {
      // Error
      print(error.response);
    });

    // Subscribe to changes in posts.
    subscription = ApiClient.realtime.subscribe([
      'databases.$APPWRITE_DATABASE_ID.collections.$POST_COLLECTION_ID.documents'
    ]);
    //Subscribe to changes in stories
    storysubscription = ApiClient.realtime.subscribe([
      'datbases.6481a01aac2dfa64e4f8.collections.6481a107205097a5ab41.documents'
    ]);

    // Call updateList every time a change has been detected.
    subscription.stream.listen((response) {
      updateList();
    });
    // Call updateStories every time change has been detected
    storysubscription.stream.listen((response) {
      updateStoryList();
    });

    // Set the list once in initState.
    updateList();
    updateStoryList();
  }

  @override
  void dispose() {
    super.dispose();

    // Close the subscription when tab is disposed.
    subscription.close();
    storysubscription.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/gs_logo.png",
                    width: 80,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Image.asset(
                      "assets/igtv.png",
                      width: 24.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Image.asset(
                      "assets/messanger.png",
                      width: 24.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: 110.0,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: StoryWid(username: users[index]),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryPage(),
                          )),
                    );
                  })),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _posts.length,
              itemBuilder: (context, i) {
                return PostWidget(
                  post: _posts[i],
                  id: i,
                  likePost: likePost,
                );
              },
            ),
          ),
          Container(
            height: 0.5,
            color: Color(0x55FFFFFF),
          ),
        ],
      ),
    );
  }
}

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

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
            final user = _sampleuser[pageIndex];
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
          pageLength: _sampleuser.length,
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

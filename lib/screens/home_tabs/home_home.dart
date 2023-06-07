import 'package:instagram/consts/constants.dart';
import 'package:flutter/material.dart';
import 'package:instagram/api/client.dart';
import 'package:instagram/models/post_model.dart';
import 'package:instagram/widgets/post.dart';
import 'package:instagram/widgets/story.dart';
import 'package:story/story_image.dart';
import 'package:story/story_page_view.dart';

class HomeHomeTab extends StatefulWidget {
  const HomeHomeTab({Key? key}) : super(key: key);

  @override
  _HomeHomeTab createState() => _HomeHomeTab();
}

class UserModel {
  UserModel(this.stories, this.userName, this.imageUrl);

  final List<StoryModel> stories;
  final String userName;
  final String imageUrl;
}

class StoryModel {
  StoryModel(this.imageUrl);

  final String imageUrl;
}

class _HomeHomeTab extends State<HomeHomeTab> {
  String _username = "";

  var subscription;

  List<Post> _posts = [
    Post(
        previewImageURL: "",
        githubURL: 'https://github.com/foss42/api-dash',
        image: "assets/profile_4.png",
        name: "joshua_l",
        location: "Tokyo, Japan",
        post: "assets/post.png",
        caption:
            "joshua_l The game in Japan was amazing and I want to share some photos",
        date: "September 19",
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
          _posts.add(Post(
            previewImageURL: docs[i].data["previewImageURL"],
            githubURL: docs[i].data["githubURL"],
            name: docs[i].data["username"],
            caption: docs[i].data["caption"],
            post: docs[i].data["imageId"],
            image: "assets/profile_$profileId.png",
          ));
        });
        print(_posts);
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

    // Call updateList every time a change has been detected.
    subscription.stream.listen((response) {
      updateList();
    });

    // Set the list once in initState.
    updateList();
  }

  @override
  void dispose() {
    super.dispose();

    // Close the subscription when tab is disposed.
    subscription.close();
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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  child: StoryWid(),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryPage(),
                      )),
                ),
                StoryWidget(
                  image: Image.asset(
                    "assets/profile.png",
                    width: 56.0,
                  ),
                  name: _username,
                  seen: false,
                ),
                StoryWidget(
                  image: Image.asset(
                    "assets/profile_1.png",
                    width: 56.0,
                  ),
                  name: "zachjohn",
                  seen: false,
                ),
                StoryWidget(
                  image: Image.asset(
                    "assets/profile_2.png",
                    width: 56.0,
                  ),
                  name: "kieron_d",
                  seen: false,
                ),
                StoryWidget(
                  image: Image.asset(
                    "assets/profile_3.png",
                    width: 56.0,
                  ),
                  name: "craig_joe",
                  seen: false,
                ),
                StoryWidget(
                  image: Image.asset(
                    "assets/profile_1.png",
                    width: 56.0,
                  ),
                  name: "zachjohn",
                  seen: false,
                ),
                StoryWidget(
                  image: Image.asset(
                    "assets/profile_2.png",
                    width: 56.0,
                  ),
                  name: "kieron_d",
                  seen: false,
                ),
                StoryWidget(
                  image: Image.asset(
                    "assets/profile_3.png",
                    width: 56.0,
                  ),
                  name: "craig_joe",
                  seen: false,
                ),
              ],
            ),
          ),
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

final sampleUsers = [
  UserModel([
    StoryModel(
        "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxN3x8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
    StoryModel(
        "https://images.unsplash.com/photo-1609418426663-8b5c127691f9?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyNXx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
    StoryModel(
        "https://images.unsplash.com/photo-1609444074870-2860a9a613e3?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1Nnx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
    StoryModel(
        "https://images.unsplash.com/photo-1609504373567-acda19c93dc4?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1MHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  ], "User1",
      "https://images.unsplash.com/photo-1609262772830-0decc49ec18c?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMDF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  UserModel([
    StoryModel(
        "https://images.unsplash.com/photo-1609439547168-c973842210e1?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4Nnx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  ], "User2",
      "https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwzMjN8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  UserModel([
    StoryModel(
        "https://images.unsplash.com/photo-1609421139394-8def18a165df?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxMDl8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
    StoryModel(
        "https://images.unsplash.com/photo-1609377375732-7abb74e435d9?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxODJ8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
    StoryModel(
        "https://images.unsplash.com/photo-1560925978-3169a42619b2?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyMjF8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
  ], "User3",
      "https://images.unsplash.com/photo-1609127102567-8a9a21dc27d8?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzOTh8fHxlbnwwfHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"),
];

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
    return Scaffold(
      body: StoryPageView(
        itemBuilder: (context, pageIndex, storyIndex) {
          final user = sampleUsers[pageIndex];
          final story = user.stories[storyIndex];
          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black),
              ),
              Positioned.fill(
                child: StoryImage(
                  key: ValueKey(story.imageUrl),
                  imageProvider: NetworkImage(
                    story.imageUrl,
                  ),
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
            if (pageIndex == 0)
              Center(
                child: ElevatedButton(
                  child: const Text('show modal bottom sheet'),
                  onPressed: () async {
                    indicatorAnimationController.value =
                        IndicatorAnimationCommand.pause;
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Look! The indicator is now paused\n\n'
                            'It will be coutinued after closing the modal bottom sheet.',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                    indicatorAnimationController.value =
                        IndicatorAnimationCommand.resume;
                  },
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
        pageLength: sampleUsers.length,
        storyLength: (int pageIndex) {
          return sampleUsers[pageIndex].stories.length;
        },
        onPageLimitReached: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

import 'dart:core';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gitsafari/api/client.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:gitsafari/models/post_model.dart';
import 'package:gitsafari/screens/home_tabs/storypage.dart';
import 'package:gitsafari/widgets/buttons.dart';
import 'package:gitsafari/widgets/post.dart';
import 'package:gitsafari/widgets/story.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class HomeHomeTab extends StatefulWidget {
  const HomeHomeTab({Key? key}) : super(key: key);

  @override
  _HomeHomeTab createState() => _HomeHomeTab();
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
        docId: '',
        upvotes: [],
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

  void upvotePost(BuildContext context, String docId, String username,
      List<dynamic> upvotes) {
    List<dynamic> newUpvoteList = upvotes;
    if (upvotes.contains(username)) {
      newUpvoteList.remove(username);
      Future result = ApiClient.databases.updateDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: POST_COLLECTION_ID,
        documentId: docId,
        data: {'upvotes': newUpvoteList},
      );
      result.then((response) {
        // Success.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Upvote removed!",
            ),
          ),
        );
      }).catchError((error) {
        // Failure.
        print(error.response);
      });
    } else {
      newUpvoteList.add(username);
      Future result = ApiClient.databases.updateDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: POST_COLLECTION_ID,
        documentId: docId,
        data: {'upvotes': newUpvoteList},
      );
      result.then((response) {
        // Success.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Post Upvoted!",
            ),
          ),
        );
      }).catchError((error) {
        // Failure.
        print(error.response);
      });
    }
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
            docId: docs[i].data['\$id'],
            upvotes: docs[i].data['upvotes'],
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

  void createNewStory(BuildContext context) {
    // return {'owner': owner, 'repoName': repoName};
    // Check if user has not selected an image yet.
    if (!_imageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Select an image.",
          ),
        ),
      );
      return;
    }
    // Create a new document in our posts collection.
    String dt = DateTime.now().toString();
    DateTime dta = DateTime.parse(dt);
    print(dt);
    print(dta);
    Future result = ApiClient.databases.createDocument(
        databaseId: "6481a01aac2dfa64e4f8",
        collectionId: "6481a107205097a5ab41",
        documentId: "unique()",
        data: {
          'username': _username,
          'image-id': _imageId,
          'createdAt': dt,
        });

    result.then((response) {
      // Success.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Story posted!",
          ),
        ),
      );
    }).catchError((error) {
      // Failure.
      print(error.response);
    });
  }

  String _username_story = "hello_there";
  String _imageId = "";

  bool _imageSelected = false;

  Future<void> selectImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    try {
      // Upload the image file to appwrite storage.
      Future result = ApiClient.storage.createFile(
        bucketId: "6481a1c504e251c5d4b0",
        fileId: "unique()",
        file: InputFile.fromPath(path: image!.path, filename: image.name),
      );

      result.then((response) {
        // Success.
        setState(() {
          _imageId = response.$id;
          _imageSelected = true;
        });
      }).catchError((error) {
        // Failure.
        print(error.response);
      });
    } catch (error) {
      // User backed out before selecting an image, do nothing.
    }
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
      'databases.6481a01aac2dfa64e4f8.collections.6481a107205097a5ab41.documents'
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
                  PopupMenuButton(
                      color: Colors.black,
                      icon: SvgPicture.asset(
                        'assets/download.svg',
                      ),
                      onSelected: (result) {
                        if (result == 0) {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  color: Color(0xff111625),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 32),
                                        child: Text(
                                          'Add a story',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 32),
                                        child: Text(
                                          'Stories disappear after 24 hours.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      GradientButton(
                                          text: "Select Image",
                                          icon: Icons.broken_image_outlined,
                                          onPressed: () => selectImage(context),
                                          width: 200),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      GradientButton(
                                          text: "Add Story",
                                          icon: Icons.add_a_photo_outlined,
                                          onPressed: () =>
                                              createNewStory(context),
                                          width: 200),
                                      Spacer(),
                                    ],
                                  ),
                                );
                              });
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 0, //---add this line
                            child: Text(
                              'Story',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ];
                      }),
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
                            builder: (context) => StoryPage(
                              sampleuser: _sampleuser,
                              storymap: _storymap,
                              users: users,
                            ),
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
                  upvotePost: upvotePost,
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

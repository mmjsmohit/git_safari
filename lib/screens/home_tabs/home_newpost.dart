import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:gitsafari/api/client.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:gitsafari/screens/home.dart';
import 'package:gitsafari/screens/repo_search.dart';
import 'package:gitsafari/utils/appwrite/avatar_api.dart';
import 'package:gitsafari/widgets/buttons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomeNewpostTab extends StatefulWidget {
  const HomeNewpostTab({super.key});

  @override
  State<HomeNewpostTab> createState() => _HomeNewpostTabState();
}

class _HomeNewpostTabState extends State<HomeNewpostTab> {
  String _imageId = "";
  String _username = "";
  Map<String, String>? result;
  final avatar = AvatarAPI();
  final TextEditingController _caption = TextEditingController();
  final TextEditingController _githubURL = TextEditingController();
  String? _language;
  bool _imageSelected = false;

  void createNewPost(BuildContext context) {
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
    Uri parsedUrl = Uri.parse(_githubURL.text);
    List<String> pathSegments = parsedUrl.pathSegments;
    String repoOwner = pathSegments[0];
    String repoName = pathSegments[1];
    // Create a new document in our posts collection.
    Future result = ApiClient.databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: POST_COLLECTION_ID,
        documentId: "unique()",
        data: {
          'username': _username,
          'imageId': _imageId,
          'caption': _caption.text,
          'githubURL': _githubURL.text,
          'repoOwner': repoOwner,
          'repoName': repoName,
          'previewImageURL':
              'https://opengraph.githubassets.com/YXBwd3JpdGVpc2F3ZXNvbWU=/$repoOwner/$repoName',
          'lang': _language?.toLowerCase(),
          'upvotes': []
        });

    result.then((response) {
      // Success.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Image posted!",
          ),
        ),
      );
    }).catchError((error) {
      // Failure.
      print(error.response);
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (Route<dynamic> route) => false);
  }

  Future<void> selectImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    try {
      // Upload the image file to appwrite storage.
      Future result = ApiClient.storage.createFile(
        bucketId: BUCKET_ID,
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

    Future result = ApiClient.account.get();
    result.then((response) {
      setState(() {
        _username = response.name;
      });
    }).catchError((error) {
      print(error.response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(0xFF121212),
        child: Column(children: [
          SizedBox(
            height: 56.0,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Builder(builder: (context) {
                    return IconButton(
                      onPressed: () async {
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      },
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                      ),
                      color: Colors.blue,
                    );
                  }),
                ),
                Spacer(),
                Text(
                  "New post",
                  style: TextStyle(
                    color: Color(0xFFF9F9F9),
                    fontSize: 16.0,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Builder(builder: (context) {
                    return IconButton(
                      onPressed: () => createNewPost(context),
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      color: Colors.blue,
                    );
                  }),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 62 + 16 * 5,
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder(
                    future: avatar.getCurrentAvatar(),
                    //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      Widget child = snapshot.hasData && snapshot.data != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                height: 64,
                                snapshot.data!,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 20,
                                child: CircularProgressIndicator(),
                              ),
                            );
                      return AnimatedSwitcher(
                        duration: Duration(seconds: 1),
                        child: child,
                      );
                    },
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientButton(
                        width: double.infinity,
                        text: 'Search for repositories',
                        icon: Icons.search,
                        onPressed: () async {
                          result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SearchList();
                              },
                            ),
                          );
                          if (result != null) {
                            print("Result received as: $result");
                            var resultLang =
                                await setLanguage(result!['languagesUrl']!);
                            setState(() {
                              _language = resultLang;
                              _githubURL.text = result!['html_url']!;
                              // print(language);

                              print('Language is: $_language');
                            });
                          }
                        },
                      ),
                      TextField(
                        controller: _githubURL,
                        style:
                            TextStyle(fontSize: 14.0, color: Color(0xFFFFFFFF)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          enabled: false,
                          fillColor: Color(0xFF121212),
                          hintText: 'Your GitHub URL Appears here!',
                          hintStyle: TextStyle(
                              fontSize: 14.0, color: Color(0x99FFFFFF)),
                        ),
                      ),
                      TextField(
                        controller: _caption,
                        style:
                            TextStyle(fontSize: 14.0, color: Color(0xFFFFFFFF)),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Color(0xFF121212),
                          hintText: 'Write a caption...',
                          hintStyle: TextStyle(
                              fontSize: 14.0, color: Color(0x99FFFFFF)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          (_imageSelected)
              ? FutureBuilder(
                  future: ApiClient.storage
                      .getFileDownload(bucketId: BUCKET_ID, fileId: _imageId),
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Image.memory(
                              // height: double.infinity,
                              snapshot.data!,
                              height: 500,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              // height: 200,
                            ),
                          )
                        : CircularProgressIndicator();
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44.0,
                    child: Builder(builder: (context) {
                      return GradientButton(
                        onPressed: () => selectImage(context),
                        text: 'Select Image',
                        width: double.infinity,
                        icon: Icons.image,
                      );
                    }),
                  ),
                ),
        ]),
      ),
    );
  }

  Future<String> setLanguage(String languagesUrl) async {
    Uri uri = Uri.parse(languagesUrl);
    var response = await http.get(uri);
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    return decodedResponse.keys.toList().first;
  }
}

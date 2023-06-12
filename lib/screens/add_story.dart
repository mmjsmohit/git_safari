import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:gitsafari/api/client.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';

class AddStory extends StatefulWidget {
  const AddStory({super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  String _username = "hello_there";
  String _imageId = "";

  bool _imageSelected = false;

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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text("Select Image"),
              onPressed: () => selectImage(context),
            ),
            ElevatedButton(
                onPressed: () {
                  createNewStory(context);
                },
                child: Text("Add Story"))
          ],
        ),
      ),
    );
  }
}

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:gitsafari/api/client.dart';
import 'package:image_picker/image_picker.dart';

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
    Future result = ApiClient.databases.createDocument(
        databaseId: "647fa08a3dadb01865c2",
        collectionId: "647fa095175374d55480",
        documentId: "unique()",
        data: {
          'username': _username,
          'image-id': _imageId,
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
  }

  Future<void> selectImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    try {
      // Upload the image file to appwrite storage.
      Future result = ApiClient.storage.createFile(
        bucketId: "647ec0289d22774ddc1b",
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

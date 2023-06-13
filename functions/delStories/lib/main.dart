import 'package:dart_appwrite/dart_appwrite.dart';

/*
  'req' variable has:
    'headers' - object with request headers
    'payload' - request body data as a string
    'variables' - object with function variables

  'res' variable has:
    'send(text, status: status)' - function to return text response. Status code defaults to 200
    'json(obj, status: status)' - function to return JSON response. Status code defaults to 200
  
  If an error is thrown, a response with code 500 will be returned.
*/

Future<void> start(final req, final res) async {
  final client = Client();

  final database = Databases(client);

  if (req.variables['APPWRITE_FUNCTION_ENDPOINT'] == null ||
      req.variables['APPWRITE_FUNCTION_API_KEY'] == null) {
    print(
        "Environment variables are not set. Function cannot use Appwrite SDK.");
  } else {
    client
        .setEndpoint(req.variables['APPWRITE_FUNCTION_ENDPOINT'])
        .setProject(req.variables['APPWRITE_FUNCTION_PROJECT_ID'])
        .setKey(req.variables['APPWRITE_FUNCTION_API_KEY'])
        .setSelfSigned(status: true);

    Future result = database.listDocuments(
        databaseId: "6481a01aac2dfa64e4f8",
        collectionId: "6481a107205097a5ab41");

    result.then((response) {
      List docs = response.documents;
      DateTime nowtime = DateTime.now();
      String temp = "";
      DateTime fetch;

      for (int i = 0; i < docs.length; ++i) {
        temp = docs[i].data['createdAt'];
        fetch = DateTime.parse(temp);

        if ((nowtime.difference(fetch)).inHours >= 24) {
          database.deleteDocument(
              databaseId: "6481a01aac2dfa64e4f8",
              collectionId: "6481a107205097a5ab41",
              documentId: docs[i].data['\$id']);
        }
      }
    });
  }

  res.json({'areDevelopersAwesome': true});
}

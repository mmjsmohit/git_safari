import 'package:appwrite/appwrite.dart';
import 'auth_api.dart';
import 'package:instagram/consts/constants.dart';

class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  addPreferences({required List preferences}) async {
    await databases.createDocument(
        databaseId: APPWRITE_DATABASE_ID,
        collectionId: POST_COLLECTION_ID,
        documentId: ID.unique(),
        data: {'preferences': preferences, 'user_id': auth.userid});
  }
}

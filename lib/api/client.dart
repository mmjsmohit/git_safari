import 'package:appwrite/appwrite.dart';

class ApiClient {
  Client get _client {
    Client client = Client();
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('almostInstagramTest')
        .setSelfSigned(status: true);

    return client;
  }

  static Account get account => Account(_instance._client);
  static Storage get storage => Storage(_instance._client);
  static Databases get databases => Databases(_instance._client);
  static Realtime get realtime => Realtime(_instance._client);

  static final ApiClient _instance = ApiClient._internal();
  ApiClient._internal();
  factory ApiClient() => _instance;
}

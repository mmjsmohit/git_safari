import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:gitsafari/consts/constants.dart';
import 'package:gitsafari/utils/appwrite/auth_api.dart';

class AvatarAPI {
  Client client = Client();
  late final Avatars avatars;
  final AuthAPI auth = AuthAPI();

  AvatarAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(APPWRITE_URL)
        .setProject(APPWRITE_PROJECT_ID)
        .setSelfSigned();
    avatars = Avatars(client);
  }

  Future<Uint8List> getInitialsAvatar(String name) {
    return avatars.getInitials(name: name);
  }

  Future<Uint8List> getCurrentAvatar() {
    return avatars.getInitials();
  }
}

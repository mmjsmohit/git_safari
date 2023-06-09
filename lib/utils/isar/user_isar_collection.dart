import 'package:isar/isar.dart';

part 'user_isar_collection.g.dart';

@collection
class UserIsarCollection {
  Id id = 0; // you can also use id = null to auto increment
  String? name;
  String? username;
  String? email;
  String? bio;
}

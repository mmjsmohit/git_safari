import 'package:flutter/foundation.dart';
import 'package:gitsafari/utils/isar/user_isar_collection.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService extends ChangeNotifier {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveUser(UserIsarCollection newUser) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.userIsarCollections.put(newUser);
    });
  }

  Future<UserIsarCollection?> getUser() async {
    final isar = await db;
    final user = await isar.userIsarCollections.get(0);
    return user;
  }

  Future<void> deleteUser() async {
    final isar = await db;
    await isar.writeTxn(() async {
      final success = await isar.userIsarCollections.delete(0);
      print('User deleted: $success');
    });
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [UserIsarCollectionSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}

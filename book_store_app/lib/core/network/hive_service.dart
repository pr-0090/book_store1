import 'package:book_store/app/constant/hive/hive_table.dart';
import 'package:book_store/features/auth/data/model/user_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}book_store.db';
    Hive.init(path);

    // Register the adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
  }

  Future<void> registerUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<UserHiveModel?> loginUser(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    var user = box.values.firstWhere(
      (user) => (user.email == email) && user.password == password,
      orElse: () => throw Exception("Invalid username or password"),
    );
    return user;
  }

  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  Future<void> deleteUser(String email) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(email);
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}

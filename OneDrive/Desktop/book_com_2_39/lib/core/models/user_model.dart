import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? token;

  @HiveField(4)
  String? role;

  @HiveField(5)
  bool isLoggedIn;

  @HiveField(6)
  DateTime? lastLogin;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.token,
    this.role,
    this.isLoggedIn = false,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle both direct user object and nested user object
    final userData = json['user'] ?? json;
    
    final user = UserModel(
      id: userData['id'] ?? userData['_id'],
      name: userData['name'],
      email: userData['email'],
      token: json['token'], // Token is at root level
      role: json['role'] ?? userData['role'],
      isLoggedIn: true,
      lastLogin: DateTime.now(),
    );
    
    print('UserModel.fromJson: Parsed user - Name: ${user.name}, Email: ${user.email}, ID: ${user.id}');
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'role': role,
      'isLoggedIn': isLoggedIn,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  void clear() {
    id = null;
    name = null;
    email = null;
    token = null;
    role = null;
    isLoggedIn = false;
    lastLogin = null;
  }
} 
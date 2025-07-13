import 'package:book_store/app/constant/hive/hive_table.dart';
import 'package:book_store/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  UserHiveModel({
    String? userId,
    required this.name,
    required this.email,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  const UserHiveModel.initial(this.email, this.password)
    : userId = '',
      name = '';

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity user) {
    return UserHiveModel(
      userId: user.userId,
      name: user.username,
      email: user.email,
      password: user.password,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      username: name,
      email: email,
      password: password,
    );
  }

  @override
  List<Object?> get props => [userId, name, email, password];
}

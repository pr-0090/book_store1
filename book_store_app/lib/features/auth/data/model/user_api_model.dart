import 'package:book_store/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String username;
  final String email;
  final String? password;

  const UserApiModel({
    this.userId,
    required this.username,
    required this.email,
    this.password,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      password: entity.password,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      username: username,
      email: email,
      password: password ?? "",
    );
  }

  @override
  List<Object?> get props => [userId, username, email, password];
}

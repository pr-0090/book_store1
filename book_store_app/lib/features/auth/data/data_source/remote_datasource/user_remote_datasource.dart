import 'package:book_store/app/constant/api_endpoints.dart';
import 'package:book_store/core/network/app_service.dart';
import 'package:book_store/features/auth/data/data_source/user_datasource.dart';
import 'package:book_store/features/auth/data/model/user_api_model.dart';
import 'package:book_store/features/auth/domain/entity/user_entity.dart';
import 'package:dio/dio.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception("Unable to login user");
      }
    } on DioException {
      throw ("Unable to login user");
    } catch (_) {
      throw ("Unable to login user");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return;
      } else {
        throw Exception('Failed to register user: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? e.message;
      throw Exception('Failed to register user: $errorMessage');
    }
  }
}

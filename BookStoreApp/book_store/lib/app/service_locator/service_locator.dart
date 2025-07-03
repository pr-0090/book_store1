import 'package:book_store/app/shared_pref/token_shared_prefs.dart';
import 'package:book_store/core/network/app_service.dart';
import 'package:book_store/core/network/hive_service.dart';
import 'package:book_store/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:book_store/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:book_store/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:book_store/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:book_store/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:book_store/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:book_store/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:book_store/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  await _initHiveService();
  await _initAuthModule();
  await _initSharedPrefs();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future<void> _initSharedPrefs() async {
  // Initialize Shared Preferences if needed
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

Future _initAuthModule() async {
  // Register ApiService
  serviceLocator.registerLazySingleton<ApiService>(() => ApiService(Dio()));

  // Data Source
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveservice: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repository
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userremoteDatasoource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => RegisterUserUseCase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  // ViewModels
  serviceLocator.registerFactory(
    () => LoginViewModel(userLoginUsecase: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => RegisterViewModel(
      registerUsecase: serviceLocator<RegisterUserUseCase>(),
    ),
  );
}

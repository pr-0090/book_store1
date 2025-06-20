import 'package:book_store/core/network/hive_service.dart';
import 'package:book_store/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:book_store/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:book_store/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:book_store/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:book_store/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:book_store/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initHiveService();
  await _initAuthModule();
  await _initSplashModule();
}

Future<void> _initHiveService() async {
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
}

Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future _initAuthModule() async {
  // Data Source
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveservice: serviceLocator<HiveService>()),
  );

  // Repository
  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  // Use Cases

  serviceLocator.registerFactory(
    () => RegisterUserUseCase(
      userRepository: serviceLocator<UserLocalRepository>(),
    ),
  );
  serviceLocator.registerFactory(
    () =>
        UserLoginUsecase(userRepository: serviceLocator<UserLocalRepository>()),
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

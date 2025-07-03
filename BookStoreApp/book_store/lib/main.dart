import 'package:book_store/app/app.dart';
import 'package:book_store/app/service_locator/service_locator.dart';
import 'package:book_store/core/network/hive_service.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  // Initialize dependency injection
  // await initDependencies();

  // Initialize Hive service
  await HiveService().init();

  // Optionally clear all Hive data
  // await HiveService().clearAll();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginViewModel>(
          create: (_) => serviceLocator<LoginViewModel>(),
        ),
        // Add other BLoCs here
      ],
      child: const App(),
    ),
  );
}

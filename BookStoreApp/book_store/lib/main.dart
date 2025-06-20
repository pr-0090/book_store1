import 'package:book_store/app/app.dart';
import 'package:book_store/app/service_locator/service_locator.dart';
import 'package:book_store/core/network/hive_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initDependencies();

  // Initialize Hive service
  await HiveService().init();

  // Optionally clear all Hive data
  // await HiveService().clearAll();

  runApp(const App()); // Make sure App has a const constructor if possible
}

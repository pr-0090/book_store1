import 'package:book_store/app/app.dart';
import 'package:book_store/app/service_locator/service_locator.dart';
import 'package:book_store/core/network/hive_service.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:book_store/features/home/domain/use_case/create_booking_usecase.dart';
import 'package:book_store/features/home/presentation/view_model/book_event.dart';
import 'package:book_store/features/home/presentation/view_model/book_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await HiveService().init();

  runApp(
    MultiBlocProvider(
      providers: [
        Provider<CreateBookingUsecase>(
          create: (_) => serviceLocator<CreateBookingUsecase>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginViewModel>(
            create: (_) => serviceLocator<LoginViewModel>(),
          ),
          BlocProvider<BookBloc>(
            create: (_) => serviceLocator<BookBloc>()..add(FetchBooksEvent()),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}

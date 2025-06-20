import 'package:book_store/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:book_store/features/auth/presentation/view/register_view.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:book_store/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:book_store/view/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel({required UserLoginUsecase userLoginUsecase})
    : _userLoginUsecase = userLoginUsecase,
      super(LoginInitial()) {
    on<LoginWithEmailAndPasswordEvent>(_loginUser);
    on<NavigateToRegisterViewEvent>(_navigateToRegister);
  }

  Future<void> _loginUser(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await _userLoginUsecase(
      UserLoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) {
        emit(LoginFailure(message: failure.message));
        ScaffoldMessenger.of(
          event.context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (user) {
        emit(LoginSuccess());
        Navigator.push(
          event.context,
          MaterialPageRoute(builder: (_) => DashboardView()),
        );
      },
    );
  }

  Future<void> _navigateToRegister(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) async {
    Navigator.push(
      event.context,
      MaterialPageRoute(builder: (_) => SignUpView()),
    );
  }
}

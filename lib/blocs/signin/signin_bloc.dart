import 'package:bloc/bloc.dart';
import 'package:firebase_bloc_todo/blocs/signin/signin_event.dart';
import 'package:firebase_bloc_todo/blocs/signin/signin_state.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/authentication_error.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';
import 'package:flutter/material.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(null);

  final UserRepository _userRepository;

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInButtonPressed) {
      yield* _mapSignInButtonPressedToState(event);
    }
  }

  Stream<SignInState> _mapSignInButtonPressedToState(
      SignInButtonPressed event) async* {
    yield SignInLoading();
    final result = await _userRepository.signIn(
      email: event.email,
      password: event.password,
    );
    if (result == FirebaseAuthResultStatus.successful) {
      yield SignInSuccess();
    } else {
      final errorMessage =
          FirebaseAuthExceptionHandler.exceptionMessage(result);
      yield SignInFailure(errorMessage);
    }
  }
}

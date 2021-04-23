import 'package:bloc/bloc.dart';
import 'package:firebase_bloc_todo/blocs/signup/signup_event.dart';
import 'package:firebase_bloc_todo/blocs/signup/signup_state.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/authentication_error.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';
import 'package:flutter/material.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({@required this.userRepository}) : super(null);

  final UserRepository userRepository;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpButtonPressed) {
      yield* _mapSignUpButtonPressedToState(event);
    }
  }

  Stream<SignUpState> _mapSignUpButtonPressedToState(
      SignUpButtonPressed event) async* {
    yield SignUpLoading();
    final result = await userRepository.signUp(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    if (result == FirebaseAuthResultStatus.successful) {
      yield SignUpSuccess(name: event.name);
    } else {
      final errorMessage =
          FirebaseAuthExceptionHandler.exceptionMessage(result);
      yield SignUpFailure(errorMessage);
    }
  }
}

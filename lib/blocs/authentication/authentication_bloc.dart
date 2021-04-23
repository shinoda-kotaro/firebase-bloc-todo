import 'package:bloc/bloc.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_event.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_state.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';
import 'package:flutter/material.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationInitial());

  final UserRepository _userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLoggedout) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    final isSignedIn = _userRepository.isSignIn();
    if (isSignedIn) {
      final _user = _userRepository.getUser();
      yield AuthenticationSuccess(_user);
    } else {
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    final _user = _userRepository.getUser();
    yield AuthenticationSuccess(_user);
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    yield AuthenticationFailure();
    _userRepository.logout();
  }
}

import 'package:equatable/equatable.dart';

class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {}

class AuthenticationLoggedout extends AuthenticationEvent {}

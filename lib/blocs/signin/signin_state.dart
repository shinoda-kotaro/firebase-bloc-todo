import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInSuccess extends SignInState {}

class SignInFailure extends SignInState {
  SignInFailure(this.errorMessage);
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

class SignInLoading extends SignInState {}

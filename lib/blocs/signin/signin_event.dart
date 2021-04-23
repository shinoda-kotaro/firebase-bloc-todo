import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInButtonPressed extends SignInEvent {
  const SignInButtonPressed({@required this.email, @required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

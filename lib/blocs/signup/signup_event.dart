import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpButtonPressed extends SignUpEvent {
  SignUpButtonPressed({this.email, this.name, this.password});
  final String email;
  final String password;
  final String name;
}

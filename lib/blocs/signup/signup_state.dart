import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpSuccess extends SignUpState {
  SignUpSuccess({this.name});
  final String name;

  @override
  List<Object> get props => [name];
}

class SignUpFailure extends SignUpState {
  SignUpFailure(this.errorMessage);
  final String errorMessage;
}

class SignUpLoading extends SignUpState {}

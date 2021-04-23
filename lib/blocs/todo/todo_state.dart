import 'package:equatable/equatable.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class ObserveTodos extends TodoState {}

class FailureObserveTodos extends TodoState {}

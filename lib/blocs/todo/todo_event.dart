import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddTodo extends TodoEvent {}

class UpdateTodo extends TodoEvent {}

class DeleteTodo extends TodoEvent {}

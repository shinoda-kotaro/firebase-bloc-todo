import 'package:equatable/equatable.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingTodos extends TodoState {}

class LoadedTodos extends TodoState {
  LoadedTodos(this.todos);
  final List<Todo> todos;

  @override
  List<Object> get props => [todos];
}

class NotLoadedTodos extends TodoState {}

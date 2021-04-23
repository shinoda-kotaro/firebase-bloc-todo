import 'package:equatable/equatable.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingTodos extends TodoState {}

class ObservingTodos extends TodoState {
  ObservingTodos(this.todos);
  final Stream<List<Todo>> todos;
}

class ObservingTodosFailure extends TodoState {}

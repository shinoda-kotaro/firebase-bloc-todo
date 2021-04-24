import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_event.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_state.dart';
import 'package:firebase_bloc_todo/repositories/todo_repository/todo_error.dart';
import 'package:firebase_bloc_todo/repositories/todo_repository/todo_repository.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(LoadingTodos());

  final todoRepository = TodoRepository();
  final userRepository = UserRepository();

  StreamSubscription subscription;

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is LoadTodos) {
      yield* _mapLoadTodosToState(event);
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdatedToState(event);
    } else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    }
  }

  Stream<TodoState> _mapLoadTodosToState(LoadTodos event) async* {
    await subscription?.cancel();
    subscription = todoRepository
        .observeTodos()
        .listen((todos) => add(TodosUpdated(todos)));
  }

  Stream<TodoState> _mapTodosUpdatedToState(TodosUpdated event) async* {
    yield LoadedTodos(event.todos);
  }

  Stream<TodoState> _mapAddTodoToState(AddTodo event) async* {
    final result = await todoRepository.addTodo(event.name);
    if (result == TodoFetchStatus.failure) {
      yield NotLoadedTodos();
    }
  }

  Stream<TodoState> _mapUpdateTodoToState(UpdateTodo event) async* {
    final result = await todoRepository.updateTodo(event.name, event.todo);
    if (result == TodoFetchStatus.failure) {
      yield NotLoadedTodos();
    }
  }

  Stream<TodoState> _mapDeleteTodoToState(DeleteTodo event) async* {
    final result = await todoRepository.deleteTodo(event.id);
    if (result == TodoFetchStatus.failure) {
      yield NotLoadedTodos();
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}

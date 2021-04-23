import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_event.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_state.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';
import 'package:firebase_bloc_todo/repositories/todo_repository/todo_repository.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(LoadingTodos());

  final todoRepository = TodoRepository();
  final userRepository = UserRepository();

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is ObserveTodos) {
      yield* _mapObserveTodosToState(event);
    } else if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    }
  }

  Stream<TodoState> _mapObserveTodosToState(ObserveTodos event) async* {
    yield ObservingTodos(todoRepository.observeTodos());
  }

  Stream<TodoState> _mapAddTodoToState(AddTodo event) async* {
    final now = DateTime.now();
    final todo = Todo(
      todoId: '',
      name: event.name,
      createdAt: Timestamp.fromDate(now),
      updatedAt: Timestamp.fromDate(now),
    );
    final firebaseTodo = Todo.toMap(todo);
    await todoRepository.addTodo(firebaseTodo);
  }

  Stream<TodoState> _mapUpdateTodoToState(UpdateTodo event) async* {
    final now = DateTime.now();
    final todo = Todo(
      todoId: '',
      name: event.name,
      createdAt: event.todo.createdAt,
      updatedAt: Timestamp.fromDate(now),
    );
    final firebaseTodo = Todo.toMap(todo);
    await todoRepository.updateTodo(firebaseTodo, event.todo.todoId);
  }

  Stream<TodoState> _mapDeleteTodoToState(DeleteTodo event) async* {}
}

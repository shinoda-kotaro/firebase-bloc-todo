import 'package:bloc/bloc.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_event.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(null);

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    }
  }

  Stream<TodoState> _mapAddTodoToState(AddTodo event) async* {}

  Stream<TodoState> _mapUpdateTodoToState(UpdateTodo event) async* {}

  Stream<TodoState> _mapDeleteTodoToState(DeleteTodo event) async* {}
}

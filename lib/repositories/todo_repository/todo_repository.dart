import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';
import 'package:firebase_bloc_todo/repositories/todo_repository/todo_error.dart';

class TodoRepository {
  final _db = FirebaseFirestore.instance;

  Stream<List<Todo>> observeTodos() {
    return _db.collection('todo').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Todo.fromDoc(doc)).toList());
  }

  Future<TodoFetchStatus> addTodo(String name) async {
    try {
      final now = DateTime.now();
      final todo = Todo(
        todoId: '',
        name: name,
        createdAt: Timestamp.fromDate(now),
        updatedAt: Timestamp.fromDate(now),
      );
      final firebaseTodo = Todo.toMap(todo);
      await _db.collection('todo').add(firebaseTodo);
      return TodoFetchStatus.success;
    } on FirebaseException catch (e) {
      print(e);
      return TodoFetchStatus.failure;
    }
  }

  Future<TodoFetchStatus> updateTodo(String name, Todo oldTodo) async {
    try {
      final now = DateTime.now();
      final todo = Todo(
        todoId: oldTodo.todoId,
        name: name,
        createdAt: oldTodo.createdAt,
        updatedAt: Timestamp.fromDate(now),
      );
      final firebaseTodo = Todo.toMap(todo);
      await _db.collection('todo').doc(oldTodo.todoId).update(firebaseTodo);
      return TodoFetchStatus.success;
    } on FirebaseException catch (e) {
      print(e);
      return TodoFetchStatus.failure;
    }
  }

  Future<TodoFetchStatus> deleteTodo(String id) async {
    try {
      await _db.collection('todo').doc(id).delete();
      return TodoFetchStatus.success;
    } on FirebaseException catch (e) {
      print(e);
      return TodoFetchStatus.failure;
    }
  }
}

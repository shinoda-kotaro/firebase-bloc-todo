import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';

class TodoRepository {
  final _db = FirebaseFirestore.instance;

  Stream<List<Todo>> observeTodos() {
    return _db.collection('todo').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Todo.fromDoc(doc)).toList());
  }

  void addTodo(String name) {
    print('adding?');
    // try {
    //   print('repository adding');
    //   final now = DateTime.now();
    //   final todo = Todo(
    //     todoId: '',
    //     name: name,
    //     createdAt: Timestamp.fromDate(now),
    //     updatedAt: Timestamp.fromDate(now),
    //   );
    //   final firebaseTodo = Todo.toMap(todo);
    //   _db.collection('todo').add(firebaseTodo);
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
    final now = DateTime.now();
    final todo = Todo(
      todoId: '',
      name: name,
      createdAt: Timestamp.fromDate(now),
      updatedAt: Timestamp.fromDate(now),
    );
    final firebaseTodo = Todo.toMap(todo);
    _db.collection('todo').add(firebaseTodo).catchError(print);
  }

  Future<void> updateTodo(String name, Todo oldTodo) async {
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
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _db.collection('todo').doc(id).delete();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}

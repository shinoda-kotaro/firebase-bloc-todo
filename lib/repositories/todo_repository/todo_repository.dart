import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';

class TodoRepository {
  final _db = FirebaseFirestore.instance;

  Stream<List<Todo>> observeTodos() {
    return _db.collection('todo').snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => Todo.fromDoc(doc)).toList());
  }

  Future<void> addTodo(Map<String, dynamic> todo) async {
    try {
      await _db.collection('todo').add(todo);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> updateTodo(Map<String, dynamic> todo, String id) async {
    try {
      await _db.collection('todo').doc(id).update(todo);
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

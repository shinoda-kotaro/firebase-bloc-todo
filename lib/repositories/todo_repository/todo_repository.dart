import 'package:cloud_firestore/cloud_firestore.dart';

class TodoRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addTodo(Map<String, dynamic> todo) async {
    await _db.collection('todo').add(todo);
  }

  Future<void> updateTodo(Map<String, dynamic> todo, String id) async {
    await _db.collection('todo').doc(id).update(todo);
  }

  Future<void> deleteTodo(String id) async {
    await _db.collection('todo').doc(id).delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Todo {
  // コンストラクター
  Todo({
    @required this.todoId,
    @required this.name,
    @required this.createdAt,
    @required this.updatedAt,
  });

  // ドキュメントをTodoにするメソッド
  factory Todo.fromDoc(QueryDocumentSnapshot doc) {
    return Todo(
      todoId: doc.id,
      name: doc.data()['name'] as String,
      createdAt: doc.data()['createdAt'] as Timestamp,
      updatedAt: doc.data()['updatedAt'] as Timestamp,
    );
  }

  final String todoId;
  final String name;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  // TodoをFirestore用にMapにする関数
  static Map<String, dynamic> toMap(Todo todo) {
    return <String, dynamic>{
      'name': todo.name,
      'createdAt': todo.createdAt,
      'updatedAt': todo.updatedAt,
    };
  }
}

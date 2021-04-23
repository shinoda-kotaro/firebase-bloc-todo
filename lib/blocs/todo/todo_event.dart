import 'package:equatable/equatable.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';
import 'package:flutter/material.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ObserveTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  AddTodo({@required this.name});
  final String name;
}

class UpdateTodo extends TodoEvent {
  UpdateTodo({@required this.todo, @required this.name});
  final Todo todo;
  final String name;
}

class DeleteTodo extends TodoEvent {
  DeleteTodo({@required this.id});
  final String id;
}

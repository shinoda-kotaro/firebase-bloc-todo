import 'package:equatable/equatable.dart';
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

class UpdateTodo extends TodoEvent {}

class DeleteTodo extends TodoEvent {}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_bloc.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_event.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_bloc.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    print('TodoScreen');

    return BlocProvider<TodoBloc>(
      create: (_) => TodoBloc(),
      child: const TodoList(),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        actions: [
          FlatButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedout());
            },
            child: Text(
              'ログアウト',
              style: const TextStyle().copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return _listItem(index);
            },
          );
        },
      ),
    );
  }

  Widget _listItem(int index) {
    return const ListTile(
      title: const Text('title'),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_bloc.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodoScreen extends HookWidget {
  const TodoScreen({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    print('TodoScreen');

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
      body: Center(
        child: Text(user.displayName),
      ),
    );
  }
}

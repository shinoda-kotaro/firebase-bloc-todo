import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_bloc.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_event.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_bloc.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_event.dart';
import 'package:firebase_bloc_todo/blocs/todo/todo_state.dart';
import 'package:firebase_bloc_todo/entities/todo.dart';
import 'package:firebase_bloc_todo/view/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    print('TodoScreen');

    return BlocProvider<TodoBloc>(
      create: (_) => TodoBloc()..add(ObserveTodos()),
      child: const TodoList(),
    );
  }
}

class TodoList extends HookWidget {
  const TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TodoList');

    final _textController =
        useTextEditingController.fromValue(TextEditingValue.empty);

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
        // ignore: missing_return
        builder: (context, state) {
          if (state is ObservingTodos) {
            return StreamBuilder(
              stream: state.todos,
              builder: (BuildContext context, AsyncSnapshot<List<Todo>> todos) {
                if (todos.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                }
                if (todos.hasError) {
                  return Center(child: Text('エラーが発生しました: ${todos.error}'));
                }
                if (todos.hasData) {
                  return ListView.builder(
                    itemCount: todos.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _listItem(index, todos.data[index]);
                    },
                  );
                } else {
                  return const Center(child: Text('データが見つかりませんでした'));
                }
              },
            );
          } else if (state is ObservingTodosFailure) {
            return const Center(child: Text('エラーが発生しました'));
          } else if (state is LoadingTodos) {
            return const LoadingScreen();
          } else {
            return Center(child: Text(state.toString()));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<String>(
            context: context,
            builder: (context) => addDialog(context, _textController),
          );
          _textController.clear();
          if (result.isNotEmpty) {
            BlocProvider.of<TodoBloc>(context).add(AddTodo(name: result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _listItem(int index, Todo todo) {
    return ListTile(
      title: Text(todo.name),
    );
  }

  AlertDialog addDialog(
      BuildContext context, TextEditingController controller) {
    return AlertDialog(
      title: const Text('新規作成'),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('作成'),
        ),
      ],
    );
  }
}

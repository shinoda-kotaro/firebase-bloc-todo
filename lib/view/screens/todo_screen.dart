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
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    print('TodoScreen');

    return BlocProvider<TodoBloc>(
      create: (_) => TodoBloc()..add(LoadTodos()),
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

    useEffect(() {
      return context.read<TodoBloc>().close;
    }, []);

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
          if (state is LoadedTodos) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (BuildContext context, int index) {
                return _listItem(
                  index,
                  state.todos[index],
                  _textController,
                  context,
                );
              },
            );
          } else if (state is NotLoadedTodos) {
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
            builder: (context) => dialog(context, _textController, '新規作成'),
          );
          _textController.clear();

          if (result == null) {
            return null;
          }

          if (result.isNotEmpty) {
            context.read<TodoBloc>().add(AddTodo(name: result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _listItem(
    int index,
    Todo todo,
    TextEditingController controller,
    BuildContext context,
  ) {
    return Slidable(
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => BlocProvider.of<TodoBloc>(context)
              .add(DeleteTodo(id: todo.todoId)),
        ),
      ],
      actionPane: const SlidableDrawerActionPane(),
      child: ListTile(
        onTap: () async {
          controller.text = todo.name;
          final result = await showDialog<String>(
            context: context,
            builder: (context) => dialog(context, controller, '編集'),
          );
          controller.clear();

          if (result == null) {
            return null;
          }

          if (result.isNotEmpty && result != todo.name) {
            context.read<TodoBloc>().add(UpdateTodo(todo: todo, name: result));
          }
        },
        title: Text(todo.name),
      ),
    );
  }

  AlertDialog dialog(
    BuildContext context,
    TextEditingController controller,
    String title,
  ) {
    return AlertDialog(
      title: Text(title),
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
          child: const Text('OK'),
        ),
      ],
    );
  }
}

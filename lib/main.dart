import 'package:firebase_bloc_todo/blocs/authentication/authentication_bloc.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_event.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_state.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';
import 'package:firebase_bloc_todo/view/screens/loading.dart';
import 'package:firebase_bloc_todo/view/screens/login.dart';
import 'package:firebase_bloc_todo/view/screens/todo_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _userRepository = UserRepository();

  runApp(
    BlocProvider(
      create: (_) => AuthenticationBloc(userRepository: _userRepository)
        ..add(AuthenticationStarted()),
      child: MyApp(userRepository: _userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.userRepository}) : super(key: key);

  final UserRepository userRepository;
  @override
  Widget build(BuildContext context) {
    print('MyApp');

    return MaterialApp(
      title: 'タイトル',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        // ignore: missing_return
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return const LoadingScreen();
          } else if (state is AuthenticationSuccess) {
            return TodoScreen(user: state.user);
          } else if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: userRepository);
          }
        },
      ),
    );
  }
}

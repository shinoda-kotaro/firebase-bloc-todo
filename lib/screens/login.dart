import 'package:email_validator/email_validator.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_bloc.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_event.dart';
import 'package:firebase_bloc_todo/blocs/signin/signIn_bloc.dart';
import 'package:firebase_bloc_todo/blocs/signin/signin_event.dart';
import 'package:firebase_bloc_todo/blocs/signin/signin_state.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';
import 'package:firebase_bloc_todo/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key, @required this.userRepository}) : super(key: key);

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    print('LoginScreen');

    return BlocProvider(
      create: (_) => SignInBloc(userRepository: userRepository),
      child: LoginForm(userRepository: userRepository),
    );
  }
}

class LoginForm extends HookWidget {
  const LoginForm({Key key, @required this.userRepository}) : super(key: key);

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    print('LoginForm');

    final _formKey = GlobalKey<FormState>();
    final _emailFocusNode = useFocusNode();
    final _passFocusNode = useFocusNode();
    final _emailController =
        useTextEditingController.fromValue(const TextEditingValue(text: ''));
    final _passController =
        useTextEditingController.fromValue(const TextEditingValue(text: ''));
    final _errorMessage = useState('');

    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
        } else if (state is SignInFailure) {
          _errorMessage.value = state.errorMessage;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('ログイン'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(flex: 1),
                  Text(
                    _errorMessage.value,
                    style: const TextStyle().copyWith(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    decoration: InputDecoration(
                      labelText: 'email',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _emailController.clear,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      _emailFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_passFocusNode);
                    },
                    validator: (value) {
                      return EmailValidator.validate(value)
                          ? null
                          : '無効なメールアドレスです';
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passController,
                    focusNode: _passFocusNode,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'password',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _passController.clear,
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      _passFocusNode.unfocus();
                    },
                    validator: (value) {
                      return value.length > 5 ? null : '短すぎます。6文字以上にしてください。';
                    },
                  ),
                  const Spacer(flex: 1),
                  ElevatedButton(
                    child: const Text('ログイン'),
                    onPressed: () async {
                      if (state is SignInLoading) {
                        return null;
                      }
                      if (_formKey.currentState.validate()) {
                        context.read<SignInBloc>().add(SignInButtonPressed(
                              email: _emailController.text,
                              password: _passController.text,
                            ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: (state is SignInLoading)
                          ? Colors.grey
                          : Theme.of(context).accentColor,
                      onPrimary: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true)
                        .push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (_) =>
                              SignupScreen(userRepository: userRepository)),
                    ),
                    child: const Text('すでにアカウントをお持ちの方'),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

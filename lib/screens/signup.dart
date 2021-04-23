import 'package:email_validator/email_validator.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_bloc.dart';
import 'package:firebase_bloc_todo/blocs/authentication/authentication_event.dart';
import 'package:firebase_bloc_todo/blocs/signup/signup_bloc.dart';
import 'package:firebase_bloc_todo/blocs/signup/signup_event.dart';
import 'package:firebase_bloc_todo/blocs/signup/signup_state.dart';
import 'package:firebase_bloc_todo/repositories/user_repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignupScreen extends HookWidget {
  const SignupScreen({Key key, @required this.userRepository})
      : super(key: key);

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(userRepository: userRepository),
      child: SignupForm(userRepository: userRepository),
    );
  }
}

class SignupForm extends HookWidget {
  const SignupForm({Key key, @required this.userRepository}) : super(key: key);

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    print('Signup');

    final _formKey = GlobalKey<FormState>();
    final _emailFocusNode = useFocusNode();
    final _passFocusNode = useFocusNode();
    final _usernameController =
        useTextEditingController.fromValue(const TextEditingValue(text: ''));
    final _emailController =
        useTextEditingController.fromValue(const TextEditingValue(text: ''));
    final _passController =
        useTextEditingController.fromValue(const TextEditingValue(text: ''));
    final _errorMessage = useState('');

    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
          Navigator.pop(context);
        } else if (state is SignUpFailure) {
          _errorMessage.value = state.errorMessage;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('新規登録'),
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
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'user name',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _usernameController.clear,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    validator: (value) {
                      return value.isEmpty ? '入力してください' : null;
                    },
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
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'password',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _passController.clear,
                      ),
                    ),
                    validator: (value) {
                      return value.length > 5 ? null : '短すぎます。6文字以上にしてください。';
                    },
                  ),
                  const Spacer(flex: 1),
                  ElevatedButton(
                    child: const Text('新規登録'),
                    onPressed: () {
                      if (state is SignUpLoading) {
                        return null;
                      }
                      if (_formKey.currentState.validate()) {
                        context.read<SignUpBloc>().add(SignUpButtonPressed(
                              email: _emailController.text,
                              password: _passController.text,
                              name: _usernameController.text,
                            ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: (state is SignUpLoading)
                          ? Colors.grey
                          : Theme.of(context).accentColor,
                      onPrimary: Colors.white,
                    ),
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

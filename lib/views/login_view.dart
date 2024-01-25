import 'package:flutter/material.dart';
import 'package:pnotes/services/auth/auth_exceptions.dart';
import 'package:pnotes/services/auth/bloc/auth_bloc.dart';
import 'package:pnotes/services/auth/bloc/auth_events.dart';
import '../constants/routes.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          Card(
            child: TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: "Please enter your email address"),
            ),
          ),
          Card(
            child: TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter a password"),
            ),
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is InvalidCredentialAuthException) {
                  await showErrorDialog(context, 'Invalid credentials');
                } else {
                  await showErrorDialog(context, 'Authentication error');
                }
              }
            },
            child: Card(
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () async {

                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                      AuthEventLogIn(
                          email,
                          password
                      )
                  );
                },
                child: const Text("Login"),
              ),
            ),
          ),
          Card(
            child: TextButton(onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
                child: const Text("Not an user? Please register!"),
            ),
          )
        ],
      ),
    );
  }
}

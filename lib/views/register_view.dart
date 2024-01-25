import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pnotes/services/auth/auth_exceptions.dart';
import 'package:pnotes/services/auth/bloc/auth_events.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
  listener: (context, state) async {
    if (state is AuthStateRegistering) {
      if (state.exception is WeakPasswordAuthException) {
        await showErrorDialog(context, 'Weak Password');
      } else if (state.exception is EmailAlreadyInUseAuthException) {
        await showErrorDialog(context, 'Email is already in use');
      } else if (state.exception is InvalidEmailAuthException) {
        await showErrorDialog(context, 'Invalid email');
      } else if (state.exception is GenericAuthException){
        await showErrorDialog(context, 'Failed to register');
      }
    }
  },
  child: Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
          Card(
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
              onPressed: () async {

                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(
                  AuthEventRegister(
                    email,
                    password,
                  ),
                );
              },
              child: const Text("Register"),
            ),
          ),
          Card(
            child: TextButton(onPressed: () {
              context.read<AuthBloc>().add(
                const AuthEventLogOut(),
              );
            },
              child: const Text("Already an user? Login!"),
            ),
          )
        ],
      ),
    ),
);
  }
}

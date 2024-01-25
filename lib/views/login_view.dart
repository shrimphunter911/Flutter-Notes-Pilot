import 'package:flutter/material.dart';
import 'package:pnotes/services/auth/auth_exceptions.dart';
import 'package:pnotes/services/auth/bloc/auth_bloc.dart';
import 'package:pnotes/services/auth/bloc/auth_events.dart';
import 'package:pnotes/utilities/dialogs/loading_dialog.dart';
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
  CloseDialog? _closeDialogHandle;

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
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
                context: context,
                text: 'Loading...'
            );
          }
          if (state.exception is InvalidCredentialAuthException) {
            await showErrorDialog(context, 'Invalid credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentication error');
          }
        }
      },
      child: Scaffold(
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
          Card(
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
          Card(
            child: TextButton(onPressed: () {
              context.read<AuthBloc>().add(
                const AuthEventShouldRegister(),
              );
            },
                child: const Text("Not an user? Please register!"),
            ),
          )
        ],
      ),
    ),
);
  }
}

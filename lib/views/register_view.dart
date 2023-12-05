import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../constants/routes.dart';
import '../utilities/show_error_log.dart';

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
    return Scaffold(
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
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    await showErrorDialog(context, "Try stronger password");
                  }
                  else if (e.code == 'email-already-in-use') {
                    await showErrorDialog(context, "Try a different email");
                  }
                  else if (e.code == 'invalid-email') {
                    await showErrorDialog(context, "Invalid email");
                  }
                  else {
                    await showErrorDialog(
                      context,
                      'Error: ${e.code}',
                    );
                  }
                } catch (e) {
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              },
              child: const Text("Register"),
            ),
          ),
          Card(
            child: TextButton(onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
              child: const Text("Already an user? Login!"),
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          Card(
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.primary),
              onPressed: () async {

                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: email,
                      password: password
                  );
                  print(userCredential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                    print("Invalid email or password");
                  }
                }
              },
              child: const Text("Login"),
            ),
          ),
          Card(
            child: TextButton(onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
            },
                child: const Text("Not an user? Please register!"),
            ),
          )
        ],
      ),
    );
  }
}
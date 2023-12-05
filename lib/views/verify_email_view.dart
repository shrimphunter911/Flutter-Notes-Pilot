import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(children: [
        Card(child: const Text("Email verification sent. If you have not received it yet, click the button below")),
        Card(
          child: TextButton(onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          }, child: const Text("Send email verification"),),
        ),
        Card(
          child: TextButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false
            );
          }, child: const Text("Restart")),
        )
      ],),
    );
  }
}
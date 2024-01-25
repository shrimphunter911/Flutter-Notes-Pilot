import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pnotes/services/auth/bloc/auth_bloc.dart';
import 'package:pnotes/services/auth/bloc/auth_events.dart';

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
          child: TextButton(onPressed: () {
            context.read<AuthBloc>().add(
              const AuthEventSendEmailVerification()
            );
          }, child: const Text("Send email verification"),),
        ),
        Card(
          child: TextButton(onPressed: () async {
            context.read<AuthBloc>().add(
              const AuthEventLogOut(),
            );
          }, child: const Text("Restart")),
        )
      ],),
    );
  }
}
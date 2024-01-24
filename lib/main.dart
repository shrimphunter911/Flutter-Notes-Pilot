import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pnotes/services/auth/auth_service.dart';
import 'package:pnotes/services/auth/bloc/auth_bloc.dart';
import 'package:pnotes/services/auth/bloc/auth_events.dart';
import 'package:pnotes/services/auth/bloc/auth_state.dart';
import 'package:pnotes/services/auth/firebase_auth_provider.dart';
import 'package:pnotes/views/login_view.dart';
import 'package:pnotes/views/notes/create_update_note_view.dart';
import 'package:pnotes/views/notes/notes_view.dart';
import 'package:pnotes/views/register_view.dart';
import 'package:pnotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
import 'constants/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
    ),
    home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
    ),
    routes: {
      loginRoute : (context) => const LoginView(),
      registerRoute : (context) => const RegisterView(),
      notesRoute : (context) => const NoteView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NoteView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator()
          );
        }
    },);
  }
}
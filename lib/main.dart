import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pnotes/helpers/loading/loading_screen.dart';
import 'package:pnotes/services/auth/bloc/auth_bloc.dart';
import 'package:pnotes/services/auth/bloc/auth_events.dart';
import 'package:pnotes/services/auth/bloc/auth_state.dart';
import 'package:pnotes/services/auth/firebase_auth_provider.dart';
import 'package:pnotes/views/forgot_password_view.dart';
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
    debugShowCheckedModeBanner: false,
    theme: ThemeData(

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
    ),
    home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText ?? 'Please wait');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NoteView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator()
          );
        }
    },);
  }
}
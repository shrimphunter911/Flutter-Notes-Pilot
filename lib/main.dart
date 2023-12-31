import 'package:flutter/material.dart';
import 'package:pnotes/services/auth/auth_service.dart';
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

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
    ),
    home: const HomePage(),
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
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot){
        switch (snapshot.connectionState){
          case ConnectionState.done:
          final user = AuthService.firebase().currentUser;
          if (user != null) {
            if (user.isEmailVerified) {
              return const NoteView();
            } else {
              return const VerifyEmailView();
            }
          } else {
            return const LoginView();
          }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}


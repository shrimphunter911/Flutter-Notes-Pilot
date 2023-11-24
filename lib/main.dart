import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pnotes/views/login_view.dart';
import 'package:pnotes/views/register_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
    ),
    home: const HomePage(),
  ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.done:
              final user = (FirebaseAuth.instance.currentUser);
              if (user?.emailVerified == true){
                return const Text("Done and email is verified");
              } else {
                return const Text("Done but email is not verified");
              }

            default:
              return const Text("Loading");
          }
        },
      ),
    );
  }
}



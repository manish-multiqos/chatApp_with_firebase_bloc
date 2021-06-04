import 'package:chatapp/UI/HomeScreen.dart';
import 'package:chatapp/UI/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/Auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc()..add(AuthCheck()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthFailure) {
            return LoginScreen();
          }

          if (state is AuthSuccess) {
            return HomeScreen(state.number);
          }

          return Scaffold(
            body: Container(),
          );
        },
      ),
    );
  }
}

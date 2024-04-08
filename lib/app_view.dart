import 'package:boulderbuds/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:boulderbuds/screens/home/home_screen.dart';
import 'package:boulderbuds/screens/authentication/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boulder Buds',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Colors.blueAccent,
          onPrimary: Colors.black,
          secondary: Colors.blue,
          onSecondary: Colors.white,
          tertiary: Colors.lightBlueAccent,
          error: Colors.red,
          outline: Colors.grey,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      }),
    );
  }
}

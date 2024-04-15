import 'package:boulderbuds/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:boulderbuds/blocs/get_gym_bloc/get_gym_bloc.dart';
import 'package:boulderbuds/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:boulderbuds/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:boulderbuds/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:boulderbuds/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:boulderbuds/screens/home/home_screen.dart';
import 'package:boulderbuds/screens/authentication/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_repository/gym_repository.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boulder Buds',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          background: Colors.black,
          onBackground: Colors.white,
          primary: Color.fromARGB(255, 174, 73, 139),
          onPrimary: Colors.black,
          secondary: Colors.blue,
          onSecondary: Colors.white,
          tertiary: Color.fromARGB(255, 113, 12, 78),
          error: Colors.white,
          outline: Colors.grey,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository),
              ),
              BlocProvider(
                create: (context) => UpdateUserInfoBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository),
              ),
              BlocProvider(
                create: (context) => MyUserBloc(
                    myUserRepository:
                        context.read<AuthenticationBloc>().userRepository)
                  ..add(GetMyUser(
                      myUserId:
                          context.read<AuthenticationBloc>().state.user!.uid)),
              ),
              BlocProvider(
                create: (context) => GetUsersBloc(
                  userRepository:
                      context.read<AuthenticationBloc>().userRepository,
                ),
              ),
              BlocProvider(
                  create: (context) => GetGymBloc(
                        gymRepository: FirebaseGymRepository(),
                      )),
            ],
            child: const HomeScreen(),
          );
        } else {
          return MultiBlocProvider(providers: [
            BlocProvider(
                create: (context) => GetGymBloc(
                      gymRepository: FirebaseGymRepository(),
                    )..add(GetGyms())),
          ], child: const WelcomeScreen());
          //return const WelcomeScreen();
        }
      }),
    );
  }
}

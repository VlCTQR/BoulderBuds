import 'package:boulderbuds/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:boulderbuds/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:boulderbuds/screens/home/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class IncomingContent extends StatefulWidget {
  const IncomingContent({super.key});

  @override
  State<IncomingContent> createState() => _IncomingContentState();
}

class _IncomingContentState extends State<IncomingContent> {
  final FirebaseUserRepository _userRepository = FirebaseUserRepository();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        if (state.status == MyUserStatus.success) {
          final currentUser = state.user!;

          return Column(
            children: [
              const SizedBox(height: 10),
              Flexible(
                child: StreamBuilder<List<MyUser>>(
                  stream: _userRepository.getUsersCollectionStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text('Error loading users');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No users found');
                    }

                    final users = snapshot.data!.where((user) {
                      //Check if other user requested
                      if (currentUser.incoming != null) {
                        if (currentUser.incoming!.contains(user.id)) {
                          return true;
                        }
                      }

                      return false;
                    }).toList();

                    if (users.isEmpty) {
                      // If there are no incoming requests, show a message
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "You don't have any incoming buddy requests.",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserWidget(
                            myUser: user,
                            currentUser: currentUser,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

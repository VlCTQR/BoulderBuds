import 'dart:developer';

import 'package:boulderbuds/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:boulderbuds/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:boulderbuds/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:boulderbuds/screens/home/buddy_preferences_edit_widget.dart';
import 'package:boulderbuds/screens/home/buddy_preferences_widget.dart';
import 'package:boulderbuds/screens/home/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
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
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, -2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: BlocProvider<UpdateUserInfoBloc>(
                          create: (context) => UpdateUserInfoBloc(
                              userRepository: FirebaseUserRepository()),
                          child: BuddyPreferencesEditWidget(
                            myUser: currentUser,
                            userRepository: FirebaseUserRepository(),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    BuddyPreferencesWidget(myUser: currentUser),
                    Expanded(
                      child: Icon(
                        Icons.tune,
                        size: 35,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
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
                      //Remove currentUser from list
                      if (user.id == currentUser.id) {
                        return false;
                      }

                      //Check if other user is buddy
                      if (currentUser.buddies != null) {
                        if (currentUser.buddies!.contains(user.id)) {
                          return false;
                        }
                      }

                      //Check if other user requested
                      if (currentUser.incoming != null) {
                        if (currentUser.incoming!.contains(user.id)) {
                          return false;
                        }
                      }

                      //Check if outgoing request
                      if (currentUser.outgoing != null) {
                        if (currentUser.outgoing!.contains(user.id)) {
                          return false;
                        }
                      }

                      //Filter on gym
                      if (user.gym != currentUser.gym) {
                        return false;
                      }

                      //Filter on gender Current User
                      if (!currentUser.searchGender!.contains('a') &&
                          currentUser.searchGender!.isNotEmpty) {
                        //If doesn't contain "All"
                        if (!currentUser
                            .searchGender! //If user.gender not in searchGender list
                            .contains(user.gender)) {
                          return false;
                        }
                      }

                      //Filter on gender User
                      if (!user.searchGender!.contains('a') &&
                          user.searchGender!.isNotEmpty) {
                        //If doesn't contain "All"
                        if (!user
                            .searchGender! //If currentUser.gender not in searchGender list
                            .contains(currentUser.gender)) {
                          return false;
                        }
                      }

                      //Filter on age Current User
                      if (currentUser.searchAgeLow != 0 &&
                          currentUser.searchAgeHigh != 0) {
                        //If both zero -> all ages
                        if (currentUser.searchAgeLow! > user.age!) {
                          //Als searchAgeLow groter is dan user.age | dus stel age range is 17-22 en user.age is 15 dan return false
                          return false;
                        }
                        if (currentUser.searchAgeHigh! < user.age!) {
                          //Als searchAgeHigh kleiner is dan user.age | dus stel age range is 17-22 en user.age is 23 dan return false
                          return false;
                        }
                      }

                      //Filter on age User
                      if (user.searchAgeLow != 0 && user.searchAgeHigh != 0) {
                        //If both zero -> all ages
                        if (user.searchAgeLow! > currentUser.age!) {
                          //Als searchAgeLow groter is dan user.age | dus stel age range is 17-22 en user.age is 15 dan return false
                          return false;
                        }
                        if (user.searchAgeHigh! < currentUser.age!) {
                          //Als searchAgeHigh kleiner is dan user.age | dus stel age range is 17-22 en user.age is 23 dan return false
                          return false;
                        }
                      }

                      // Converteer de grade van andere users naar int
                      int? userGrade =
                          user.grade != null && user.grade!.isNotEmpty
                              ? int.tryParse(user.grade![0])
                              : null;

                      // Filter op basis van grade Current User
                      // Als searchGradeLow en searchGradeHigh beide 0 zijn, accepteer dan alle grades
                      if (currentUser.searchGradeLow == 0 &&
                          currentUser.searchGradeHigh == 0) {
                        return true;
                      }

                      if ((currentUser.searchGradeLow != null &&
                              (userGrade == null ||
                                  userGrade < currentUser.searchGradeLow!)) ||
                          (currentUser.searchGradeHigh != null &&
                              (userGrade == null ||
                                  userGrade > currentUser.searchGradeHigh!))) {
                        return false;
                      }

                      // Converteer de grade van Current User naar int
                      int? currentUserGrade = currentUser.grade != null &&
                              currentUser.grade!.isNotEmpty
                          ? int.tryParse(currentUser.grade![0])
                          : null;

                      // Filter op basis van grade User
                      // Als searchGradeLow en searchGradeHigh beide 0 zijn, accepteer dan alle grades
                      if (user.searchGradeLow == 0 &&
                          user.searchGradeHigh == 0) {
                        return true;
                      }

                      if ((user.searchGradeLow != null &&
                              (currentUserGrade == null ||
                                  currentUserGrade < user.searchGradeLow!)) ||
                          (user.searchGradeHigh != null &&
                              (currentUserGrade == null ||
                                  currentUserGrade > user.searchGradeHigh!))) {
                        return false;
                      }

                      return true;
                    }).toList();

                    if (users.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "No users found that match your preferences...",
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

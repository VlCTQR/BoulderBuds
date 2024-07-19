import 'dart:developer';

import 'package:boulderbuds/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:boulderbuds/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:boulderbuds/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:boulderbuds/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:boulderbuds/screens/account%20setup/account_setup_screen.dart';
import 'package:boulderbuds/screens/home/buddy_preferences_edit_widget.dart';
import 'package:boulderbuds/screens/home/buddy_preferences_widget.dart';
import 'package:boulderbuds/screens/home/user_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart';
import 'package:image_cropper/image_cropper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetUsersBloc>().add(GetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.success) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                centerTitle: false,
                title: BlocBuilder<MyUserBloc, MyUserState>(
                  builder: (context, state) {
                    if (state.status == MyUserStatus.success) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      BlocProvider<UpdateUserInfoBloc>(
                                    create: (context) => UpdateUserInfoBloc(
                                        userRepository:
                                            FirebaseUserRepository()),
                                    child: BlocProvider(
                                      create: (context) => SignInBloc(
                                          userRepository:
                                              FirebaseUserRepository()),
                                      child: AccountSetupScreen(
                                        title: "Your Profile",
                                        myUser: state.user!,
                                        userRepository:
                                            FirebaseUserRepository(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: state.user!.picture == ""
                                ? Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.person,
                                      color: Colors.grey[800],
                                      size: 25,
                                    ),
                                  )
                                : Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          state.user!.picture!,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Welcome ${state.user!.name.split(' ')[0].length > 10 ? state.user!.name.split(' ')[0].substring(0, 10) + '...' : state.user!.name.split(' ')[0]}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                // actions: [
                //   IconButton(
                //     onPressed: () {
                //       context.read<SignInBloc>().add(const SignOutRequired());
                //     },
                //     icon: Icon(
                //       CupertinoIcons.square_arrow_right,
                //       color: Theme.of(context).colorScheme.onBackground,
                //     ),
                //   ),
                //   IconButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute<void>(
                //           builder: (BuildContext context) =>
                //               BlocProvider<UpdateUserInfoBloc>(
                //             create: (context) => UpdateUserInfoBloc(
                //                 userRepository: FirebaseUserRepository()),
                //             child: AccountSetupScreen(
                //               title: "Your Profile",
                //               myUser: state.user!,
                //               userRepository: FirebaseUserRepository(),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //     icon: Icon(
                //       Icons.settings,
                //       color: Theme.of(context).colorScheme.onBackground,
                //     ),
                //   ),
                // ],
              ),
              body: Column(
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
                                myUser: state.user!,
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
                        BuddyPreferencesWidget(myUser: state.user!),
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
                    child: BlocBuilder<GetUsersBloc, GetUsersState>(
                      builder: (context, usersState) {
                        final currentUser = state.user!;
                        log(currentUser.toString());

                        if (usersState is GetUsersSuccess) {
                          final users = usersState.users.where((user) {
                            //Remove currentUser from list
                            if (user.id == currentUser.id) {
                              return false;
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
                            if (user.searchAgeLow != 0 &&
                                user.searchAgeHigh != 0) {
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
                                        userGrade <
                                            currentUser.searchGradeLow!)) ||
                                (currentUser.searchGradeHigh != null &&
                                    (userGrade == null ||
                                        userGrade >
                                            currentUser.searchGradeHigh!))) {
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
                                        currentUserGrade <
                                            user.searchGradeLow!)) ||
                                (user.searchGradeHigh != null &&
                                    (currentUserGrade == null ||
                                        currentUserGrade >
                                            user.searchGradeHigh!))) {
                              return false;
                            }

                            return true;
                          }).toList();
                          return ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: UserWidget(myUser: user),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

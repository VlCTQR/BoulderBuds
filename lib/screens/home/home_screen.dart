import 'dart:async';
import 'dart:developer';

import 'package:boulderbuds/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:boulderbuds/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:boulderbuds/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:boulderbuds/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:boulderbuds/screens/account%20setup/account_setup_screen.dart';
import 'package:boulderbuds/screens/home/buddies_content.dart';
import 'package:boulderbuds/screens/home/buddy_preferences_edit_widget.dart';
import 'package:boulderbuds/screens/home/buddy_preferences_widget.dart';
import 'package:boulderbuds/screens/home/home_content.dart';
import 'package:boulderbuds/screens/home/incoming_content.dart';
import 'package:boulderbuds/screens/home/user_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart';
import 'package:image_cropper/image_cropper.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  final String currentUserId;

  const HomeScreen(
      {Key? key, required this.selectedIndex, required this.currentUserId})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;
  StreamSubscription<List<MyUser>>? _userSubscription;
  MyUser? currentUser;
  bool isSubscribed = false;

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    const HomeContent(),
    const BuddiesContent(),
    const IncomingContent(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    context.read<MyUserBloc>().add(GetMyUser(myUserId: widget.currentUserId));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            currentUser = state.user!;
            // log(currentUserId);

            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                centerTitle: false,
                title: BlocBuilder<MyUserBloc, MyUserState>(
                  builder: (context, state) {
                    if (state.status == MyUserStatus.success) {
                      currentUser = state.user!;
                      // log(currentUserId);

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
                            "Welcome ${state.user!.name.split(' ')[0].length > 10 ? '${state.user!.name.split(' ')[0].substring(0, 10)}...' : state.user!.name.split(' ')[0]}",
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
              ),
              body: IndexedStack(
                index: _selectedIndex,
                children: _pages,
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.group),
                        label: 'Buddies',
                      ),
                      BottomNavigationBarItem(
                        icon: Stack(
                          children: <Widget>[
                            const Icon(Icons.notifications),
                            if (state.user!.incoming != null &&
                                state.user!.incoming!
                                    .isNotEmpty) // Only show badge if incoming requests are present
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${currentUser?.incoming?.length ?? 0}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        label: 'Incoming',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey,
                    onTap: _onItemTapped,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

import 'package:boulderbuds/components/gyms_data.dart';
import 'package:boulderbuds/components/textfield.dart';
import 'package:boulderbuds/screens/authentication/demo_widgets/buddy_preferences_edit_widget_demo.dart';
import 'package:boulderbuds/screens/home/buddy_preferences_widget.dart';
import 'package:boulderbuds/screens/home/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:boulderbuds/blocs/get_users_bloc/get_users_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_repository/user_repository.dart';
//import 'package:flutter_email_sender/flutter_email_sender.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  MyUser demoUser = MyUser(id: "", email: "", name: "");

  late List<MyUser> demoUsers;

  late List<MyUser> filteredDemoUsers;

  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // void _sendFeedback() async {
  //   if (_formKey.currentState!.validate()) {
  //     String feedback = _feedbackController.text;
  //     String subject = 'Feedback van gebruiker Boulder-Buds';
  //     String body = 'Feedback: $feedback';

  //     final Email email = Email(
  //       body: body,
  //       subject: subject,
  //       recipients: ['victor.zwaga@gmail.com'],
  //     );

  //     await FlutterEmailSender.send(email);
  //     _feedbackController.clear();

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Thank you for the feedback!')),
  //     );
  //   }
  // }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();

    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    demoUsers = [
      MyUser(
        id: "1",
        email: "",
        name: "Adam Ondra",
        gender: "m",
        age: calculateAge(DateTime(1993, 2, 5)),
        picture:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/20180227-LS-0055_by_Lukasz_Sokol.jpg/1200px-20180227-LS-0055_by_Lukasz_Sokol.jpg",
        grade: "9a",
      ),
      MyUser(
        id: "2",
        email: "",
        name: "Magnus Midtbo",
        gender: "m",
        age: calculateAge(DateTime(1988, 9, 18)),
        picture:
            "https://upload.wikimedia.org/wikipedia/commons/8/82/Magnus_Midtb%C3%B8_Innsbruck_2010.JPG",
        grade: "5b",
      ),
      MyUser(
        id: "3",
        email: "",
        name: "Janja Garnbret",
        gender: "f",
        age: calculateAge(DateTime(1999, 3, 12)),
        picture:
            "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Janja_Garnbret_2017_%28cropped%29.jpg/330px-Janja_Garnbret_2017_%28cropped%29.jpg",
        grade: "7c",
      ),
    ];
    filteredDemoUsers = demoUsers;
    context.read<GetUsersBloc>().add(GetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      child: Column(children: [
        const SizedBox(height: 50),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.5), // shadow color
                spreadRadius: 5, // spread radius
                blurRadius: 7, // blur radius
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              "🧗",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 90,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Find Climbing Buddies in Your Gym!",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 3,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        const SizedBox(height: 30),
        Text(
          "Supported Gyms",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<GetUsersBloc, GetUsersState>(
                builder: (context, usersState) {
                  if (usersState is GetUsersSuccess) {
                    final users = usersState.users;
                    Map<String, int> gymMembersCount = {};

                    // Count members for each gym
                    users.forEach((user) {
                      if (user.gym != null) {
                        gymMembersCount.update(
                          user.gym!.gymId,
                          (value) => value + 1,
                          ifAbsent: () => 1,
                        );
                      }
                    });
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: GymsData.gyms.length,
                      itemBuilder: (context, index) {
                        final gym = GymsData.gyms[index];
                        final membersCount = gymMembersCount[gym.gymId] ?? 0;
                        return ListTile(
                          title: Text(
                            "🧗 ${gym.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person),
                              Text(
                                ": $membersCount",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          //subtitle: Text("Gym ID: ${gym.gymId}"),
                          // Add onTap if you want to handle gym selection
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
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 3,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        const SizedBox(height: 30),
        Text(
          "Filter on various preferences",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "↓ Try it Out! ↓",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.onBackground,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  "Demo with well known Climbers",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 15),
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
                            child: BuddyPreferencesEditWidgetDemo(
                              myUser: demoUser,
                              onFilterApplied: (updatedUser) {
                                setState(() {
                                  demoUser = updatedUser;
                                  filteredDemoUsers = demoUsers.where((user) {
                                    // Filter on gender
                                    if (!demoUser.searchGender!.contains('a') &&
                                        demoUser.searchGender!.isNotEmpty) {
                                      if (!demoUser.searchGender!
                                          .contains(user.gender)) {
                                        return false;
                                      }
                                    }

                                    // Filter on age
                                    if (demoUser.searchAgeLow != 0 &&
                                        demoUser.searchAgeHigh != 0) {
                                      if (demoUser.searchAgeLow! > user.age!) {
                                        return false;
                                      }
                                      if (demoUser.searchAgeHigh! < user.age!) {
                                        return false;
                                      }
                                    }

                                    // Convert the grade of other users to int
                                    int? userGrade = user.grade != null &&
                                            user.grade!.isNotEmpty
                                        ? int.tryParse(user.grade![0])
                                        : null;

                                    // Filter based on grade
                                    if (demoUser.searchGradeLow == 0 &&
                                        demoUser.searchGradeHigh == 0) {
                                      return true;
                                    }

                                    if ((demoUser.searchGradeLow != null &&
                                            (userGrade == null ||
                                                userGrade <
                                                    demoUser
                                                        .searchGradeLow!)) ||
                                        (demoUser.searchGradeHigh != null &&
                                            (userGrade == null ||
                                                userGrade >
                                                    demoUser
                                                        .searchGradeHigh!))) {
                                      return false;
                                    }

                                    return true;
                                  }).toList();
                                });
                              },
                            ));
                      },
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      BuddyPreferencesWidget(myUser: demoUser),
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDemoUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredDemoUsers[index];
                      return IgnorePointer(
                        ignoring: true,
                        child: UserWidget(myUser: user),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 3,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        const SizedBox(height: 30),
        Text(
          "Connect using Social Media",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        Text(
          "only visible to people you prefer to climb with",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: GestureDetector(
            onTap: () =>
                _launchUrl(Uri.parse("https://instagram.com/adam.ondra/")),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/600px-Instagram_icon.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "@adam.ondra",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: GestureDetector(
            onTap: () => _launchUrl(
                Uri.parse("https://facebook.com/adamondraofficial/")),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/c/cd/Facebook_logo_%28square%29.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "@adamondraofficial",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: GestureDetector(
            onTap: () =>
                _launchUrl(Uri.parse("https://twitter.com/AdamOndraCZ/")),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/x-social-media-logo-icon.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "@AdamOndraCZ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 3,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) {
                    _scrollToBottom();
                  }
                },
                title: Text(
                  'Feedback Form',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                leading: Icon(
                  Icons.feedback,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                collapsedIconColor: Theme.of(context).colorScheme.onBackground,
                iconColor: Theme.of(context).colorScheme.onBackground,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyTextField(
                          controller: _feedbackController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please input your feedback';
                            }
                            return null;
                          },
                          hintText: '',
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          label: "",
                          maxLinesEnabled: true,
                          minLinesEnabled: true,
                          maxCharacters: 200,
                        ),
                        const SizedBox(height: 10),
                        Center(
                            child: ElevatedButton(
                          onPressed: () {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'victor.zwaga@gmail.com',
                              queryParameters: {
                                'subject': 'Feedback Boulder-Buds',
                                'body': _feedbackController.text,
                              },
                            );
                            launchUrl(emailLaunchUri);
                          },
                          child: const Text('Send Feedback via E-mail'),
                        )),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
        const SizedBox(height: 50),
      ]),
    );
  }
}

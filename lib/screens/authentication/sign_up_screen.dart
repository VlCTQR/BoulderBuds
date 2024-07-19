import 'package:boulderbuds/components/gyms_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_repository/gym_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../components/strings.dart';
import '../../components/textfield.dart';

import 'package:multi_dropdown/multiselect_dropdown.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:introduction_screen/introduction_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _introKey = GlobalKey<IntroductionScreenState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;

  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final gradeController = TextEditingController();

  String? selectedGender = "m";
  List<Map<String, dynamic>> possGenders = [
    {"value": "m", "label": "Male", "icon": Icons.male},
    {"value": "f", "label": "Female", "icon": Icons.female},
    {"value": "u", "label": "Other", "icon": Icons.transgender},
  ];

  bool isExpandedBuddyPrefs = false;

  List<ValueItem> selectedGendersBuddy = [];
  final MultiSelectController genderBuddyController = MultiSelectController();

  int? selectedGradeLow;
  int? selectedGradeHigh;
  List<int> grades = List.generate(9, (index) => index + 1);

  final ageSearchLowController = TextEditingController();
  final ageSearchHighController = TextEditingController();

  List<ValueItem> buddyPreferenceGenders = <ValueItem>[
    const ValueItem(label: "All", value: "a"),
    const ValueItem(label: "Male", value: "m"),
    const ValueItem(label: "Female", value: "f"),
    const ValueItem(label: "Other", value: "u"),
  ];

  Gym? selectedGym;

  List<Gym> gyms = GymsData.gyms;

  final descriptionController = TextEditingController();

  final instagramController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();

  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  void initState() {
    super.initState();
    //context.read<GetGymBloc>().add(GetGyms());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: //Column(
          //children: [
          IntroductionScreen(
        key: _introKey,
        freeze: true,
        showDoneButton: false,
        showNextButton: false,
        globalBackgroundColor: Theme.of(context).colorScheme.tertiary,
        pages: [
          PageViewModel(
            titleWidget: Text(
              "Account Details",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            bodyWidget: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: emailController,
                      label: "Email",
                      hintText: '',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(CupertinoIcons.mail_solid),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (!emailRexExp.hasMatch(val)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: passwordController,
                      label: 'Password',
                      hintText: '',
                      obscureText: obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
                      onChanged: (val) {
                        if (val!.contains(RegExp(r'[A-Z]'))) {
                          setState(() {
                            containsUpperCase = true;
                          });
                        } else {
                          setState(() {
                            containsUpperCase = false;
                          });
                        }
                        if (val.contains(RegExp(r'[a-z]'))) {
                          setState(() {
                            containsLowerCase = true;
                          });
                        } else {
                          setState(() {
                            containsLowerCase = false;
                          });
                        }
                        if (val.contains(RegExp(r'[0-9]'))) {
                          setState(() {
                            containsNumber = true;
                          });
                        } else {
                          setState(() {
                            containsNumber = false;
                          });
                        }
                        if (val.contains(specialCharRexExp)) {
                          setState(() {
                            containsSpecialChar = true;
                          });
                        } else {
                          setState(() {
                            containsSpecialChar = false;
                          });
                        }
                        if (val.length >= 8) {
                          setState(() {
                            contains8Length = true;
                          });
                        } else {
                          setState(() {
                            contains8Length = false;
                          });
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                            if (obscurePassword) {
                              iconPassword = CupertinoIcons.eye_fill;
                            } else {
                              iconPassword = CupertinoIcons.eye_slash_fill;
                            }
                          });
                        },
                        icon: Icon(
                          iconPassword,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (!passwordRexExp.hasMatch(val)) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "⚈  1 uppercase",
                          style: TextStyle(
                              color: containsUpperCase
                                  ? const Color.fromARGB(255, 152, 255, 152)
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "⚈  1 lowercase",
                          style: TextStyle(
                              color: containsLowerCase
                                  ? const Color.fromARGB(255, 152, 255, 152)
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "⚈  1 number",
                          style: TextStyle(
                              color: containsNumber
                                  ? const Color.fromARGB(255, 152, 255, 152)
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "⚈  1 special character",
                          style: TextStyle(
                              color: containsSpecialChar
                                  ? const Color.fromARGB(255, 152, 255, 152)
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                        Text(
                          "⚈  8 minimum characters",
                          style: TextStyle(
                              color: contains8Length
                                  ? const Color.fromARGB(255, 152, 255, 152)
                                  : Theme.of(context).colorScheme.onBackground),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    // Validate email
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in your email')),
                      );
                      return;
                    } else if (!emailRexExp.hasMatch(emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a valid email')),
                      );
                      return;
                    }

                    // Validate password
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in a password')),
                      );
                      return;
                    } else if (!passwordRexExp
                        .hasMatch(passwordController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a valid password')),
                      );
                      return;
                    }

                    // Proceed to next step
                    _introKey.currentState?.next();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Personal Details",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "needed to help others find you as a possible buddy",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            bodyWidget: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                      controller: nameController,
                      label: 'Name',
                      hintText: '',
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(CupertinoIcons.person_fill),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (val.length > 30) {
                          return 'Name too long';
                        } else if (!nameRegExp.hasMatch(val)) {
                          return 'Invalid characters in name';
                        }
                        return null;
                      }),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Gender",
                            style: TextStyle(
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10)),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor:
                                  Theme.of(context).colorScheme.onBackground,
                            ),
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              value: selectedGender,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGender = newValue;
                                });
                              },
                              items: possGenders
                                  .map((Map<String, dynamic> gender) {
                                return DropdownMenuItem<String>(
                                  value: gender["value"],
                                  child: Row(
                                    children: <Widget>[
                                      Icon(gender["icon"]),
                                      const SizedBox(width: 8),
                                      Text(gender["label"]),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: MyTextField(
                        controller: ageController,
                        label: 'Age',
                        hintText: '',
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.face_retouching_natural),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!ageRegExp.hasMatch(val)) {
                            return 'Please enter a valid age(1-99)';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _introKey.currentState?.previous(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "< Back",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate name
                        if (nameController.text.isEmpty) {
                          // Show error message or handle the error
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill in your name')),
                          );
                          return; // Exit the method
                        } else if (nameController.text.length > 30) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Name is too long')),
                          );
                          return;
                        } else if (!nameRegExp.hasMatch(nameController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid characters in name')),
                          );
                          return;
                        }

                        // Validate age
                        if (ageController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill in your age')),
                          );
                          return;
                        } else if (!ageRegExp.hasMatch(ageController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter a valid age (1-99)')),
                          );
                          return;
                        }

                        // Check if gender is selected
                        if (selectedGender == null || selectedGender!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select your gender')),
                          );
                          return;
                        }

                        _introKey.currentState?.next();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              "Climbing Details",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            bodyWidget: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: MyTextField(
                    controller: gradeController,
                    label: 'Grade you climb comfortably',
                    hintText: '6b',
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.trending_up),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please fill in this field';
                      } else if (!boulderingGradeRegExp.hasMatch(val)) {
                        return 'Please enter a valid climbing grade';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        "Your Gym",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Stack(
                        children: [
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              child: DropdownButtonFormField(
                                value: selectedGym,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a gym';
                                  }
                                  return null;
                                },
                                onChanged: (Gym? newValue) {
                                  setState(() {
                                    selectedGym = newValue;
                                  });
                                },
                                items: gyms.map((Gym gym) {
                                  return DropdownMenuItem<Gym>(
                                    value: gym,
                                    child: Text(gym.name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _introKey.currentState?.previous(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "< Back",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate grade
                        if (gradeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill in your grade')),
                          );
                          return;
                        } else if (!boulderingGradeRegExp
                            .hasMatch(gradeController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please enter a valid climbing grade')),
                          );
                          return;
                        }

                        // Validate gym
                        if (selectedGym == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select your gym')),
                          );
                          return;
                        }

                        // Proceed to next step
                        _introKey.currentState?.next();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              "About You",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            bodyWidget: Column(
              children: [
                Text(
                  "Tell something about yourself, your climbing career or what kind of buddy you are looking for!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: descriptionController,
                  hintText:
                      "For example:\n- How often do you climb?\n- What time do you usually climb?\n- How long have you been climbing?\n- What are you looking for in a climbing buddy?",
                  obscureText: false,
                  keyboardType: TextInputType.multiline,
                  label: "Description",
                  maxLinesEnabled: true,
                  minLinesEnabled: true,
                  maxCharacters: 200,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _introKey.currentState?.previous(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "< Back",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate description
                        if (descriptionController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill in a description')),
                          );
                          return;
                        }

                        // Proceed to next step
                        _introKey.currentState?.next();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Contact Information",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "only visible to people you have stated you want to climb with",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            bodyWidget: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  "Fill in at least one contact option",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "(more contact options means more chances of contact!)",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/600px-Instagram_icon.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextField(
                        controller: instagramController,
                        hintText: "adam.ondra",
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        label: "Instagram handle",
                        validator: (value) {
                          // Check if the value is empty or matches the Instagram username regex
                          if (value != null &&
                              value.isNotEmpty &&
                              !instagramUsernameRegExp.hasMatch(value)) {
                            return 'Invalid Instagram handle';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/c/cd/Facebook_logo_%28square%29.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextField(
                        controller: facebookController,
                        hintText: "adamondraofficial",
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        label: "Facebook handle",
                        validator: (value) {
                          // Check if the value is empty or matches the Facebook username regex
                          if (value != null &&
                              value.isNotEmpty &&
                              !facebookUsernameRegExp.hasMatch(value)) {
                            return 'Invalid Facebook handle';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Image.network(
                        "https://uxwing.com/wp-content/themes/uxwing/download/brands-and-social-media/x-social-media-logo-icon.png",
                        width: 40,
                        height: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextField(
                        controller: twitterController,
                        hintText: "AdamOndraCZ",
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        label: "Twitter handle",
                        validator: (value) {
                          // Check if the value is empty or matches the Instagram username regex
                          if (value != null &&
                              value.isNotEmpty &&
                              !twitterUsernameRegExp.hasMatch(value)) {
                            return 'Invalid Twitter handle';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _introKey.currentState?.previous(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "< Back",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validatie van de tekstvelden
                        if (emailController.text.isEmpty ||
                            nameController.text.isEmpty ||
                            ageController.text.isEmpty ||
                            gradeController.text.isEmpty ||
                            selectedGender == null ||
                            selectedGym == null) {
                          // Toon een foutmelding als niet alle velden zijn ingevuld
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please fill in all the necessary fields')),
                          );
                          return;
                        }

                        // Valideer het e-mailadres
                        if (!emailRexExp.hasMatch(emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please enter a valid email address')),
                          );
                          return;
                        }

                        // Valideer het wachtwoord
                        if (!passwordRexExp.hasMatch(passwordController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a valid password')),
                          );
                          return;
                        }

                        // Valideer de naam
                        if (!nameRegExp.hasMatch(nameController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a valid name')),
                          );
                          return;
                        }

                        // Valideer de leeftijd
                        if (!ageRegExp.hasMatch(ageController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter a valid age')),
                          );
                          return;
                        }

                        // Valideer het klimniveau
                        if (!boulderingGradeRegExp
                            .hasMatch(gradeController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please enter a valid climbing grade')),
                          );
                          return;
                        }

                        // Valideer dat minimaal één van de social media velden is ingevuld
                        if (instagramController.text.isEmpty &&
                            facebookController.text.isEmpty &&
                            twitterController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please fill in at least one social media handle')),
                          );
                          return;
                        }

                        // Maak een nieuwe MyUser en vul deze in met de gegevens uit de controllers
                        MyUser myUser = MyUser.empty;
                        myUser = myUser.copyWith(
                          email: emailController.text,
                          name: nameController.text,
                          age: int.parse(ageController.text),
                          gender: selectedGender,
                          grade: gradeController.text,
                          gym: selectedGym,
                          // Voeg de social media handles toe aan de MyUser
                          instagram: instagramController.text,
                          facebook: facebookController.text,
                          twitter: twitterController.text,
                        );

                        // Verzend de gegevens naar de SignUpBloc
                        setState(() {
                          context.read<SignUpBloc>().add(
                              SignUpRequired(myUser, passwordController.text));
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      // SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   child: Form(
      //     key: _formKey,
      //     child: Center(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 50),
      //         child: Column(
      //           children: [
      //             const SizedBox(
      //               height: 50,
      //             ),
      //             SizedBox(
      //               width: MediaQuery.of(context).size.width * 0.9,
      //               child: MyTextField(
      //                   controller: emailController,
      //                   label: "Email",
      //                   hintText: '',
      //                   obscureText: false,
      //                   keyboardType: TextInputType.emailAddress,
      //                   prefixIcon: const Icon(CupertinoIcons.mail_solid),
      //                   validator: (val) {
      //                     if (val!.isEmpty) {
      //                       return 'Please fill in this field';
      //                     } else if (!emailRexExp.hasMatch(val)) {
      //                       return 'Please enter a valid email';
      //                     }
      //                     return null;
      //                   }),
      //             ),
      //             const SizedBox(height: 10),
      //             SizedBox(
      //               width: MediaQuery.of(context).size.width * 0.9,
      //               child: MyTextField(
      //                   controller: passwordController,
      //                   label: 'Password',
      //                   hintText: '',
      //                   obscureText: obscurePassword,
      //                   keyboardType: TextInputType.visiblePassword,
      //                   prefixIcon: const Icon(CupertinoIcons.lock_fill),
      //                   onChanged: (val) {
      //                     if (val!.contains(RegExp(r'[A-Z]'))) {
      //                       setState(() {
      //                         containsUpperCase = true;
      //                       });
      //                     } else {
      //                       setState(() {
      //                         containsUpperCase = false;
      //                       });
      //                     }
      //                     if (val.contains(RegExp(r'[a-z]'))) {
      //                       setState(() {
      //                         containsLowerCase = true;
      //                       });
      //                     } else {
      //                       setState(() {
      //                         containsLowerCase = false;
      //                       });
      //                     }
      //                     if (val.contains(RegExp(r'[0-9]'))) {
      //                       setState(() {
      //                         containsNumber = true;
      //                       });
      //                     } else {
      //                       setState(() {
      //                         containsNumber = false;
      //                       });
      //                     }
      //                     if (val.contains(specialCharRexExp)) {
      //                       setState(() {
      //                         containsSpecialChar = true;
      //                       });
      //                     } else {
      //                       setState(() {
      //                         containsSpecialChar = false;
      //                       });
      //                     }
      //                     if (val.length >= 8) {
      //                       setState(() {
      //                         contains8Length = true;
      //                       });
      //                     } else {
      //                       setState(() {
      //                         contains8Length = false;
      //                       });
      //                     }
      //                     return null;
      //                   },
      //                   suffixIcon: IconButton(
      //                     onPressed: () {
      //                       setState(() {
      //                         obscurePassword = !obscurePassword;
      //                         if (obscurePassword) {
      //                           iconPassword = CupertinoIcons.eye_fill;
      //                         } else {
      //                           iconPassword =
      //                               CupertinoIcons.eye_slash_fill;
      //                         }
      //                       });
      //                     },
      //                     icon: Icon(
      //                       iconPassword,
      //                       color: Theme.of(context).colorScheme.background,
      //                     ),
      //                   ),
      //                   validator: (val) {
      //                     if (val!.isEmpty) {
      //                       return 'Please fill in this field';
      //                     } else if (!passwordRexExp.hasMatch(val)) {
      //                       return 'Please enter a valid password';
      //                     }
      //                     return null;
      //                   }),
      //             ),
      //             const SizedBox(height: 10),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       "⚈  1 uppercase",
      //                       style: TextStyle(
      //                           color: containsUpperCase
      //                               ? const Color.fromARGB(
      //                                   255, 152, 255, 152)
      //                               : Theme.of(context)
      //                                   .colorScheme
      //                                   .onBackground),
      //                     ),
      //                     Text(
      //                       "⚈  1 lowercase",
      //                       style: TextStyle(
      //                           color: containsLowerCase
      //                               ? const Color.fromARGB(
      //                                   255, 152, 255, 152)
      //                               : Theme.of(context)
      //                                   .colorScheme
      //                                   .onBackground),
      //                     ),
      //                     Text(
      //                       "⚈  1 number",
      //                       style: TextStyle(
      //                           color: containsNumber
      //                               ? const Color.fromARGB(
      //                                   255, 152, 255, 152)
      //                               : Theme.of(context)
      //                                   .colorScheme
      //                                   .onBackground),
      //                     ),
      //                   ],
      //                 ),
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       "⚈  1 special character",
      //                       style: TextStyle(
      //                           color: containsSpecialChar
      //                               ? const Color.fromARGB(
      //                                   255, 152, 255, 152)
      //                               : Theme.of(context)
      //                                   .colorScheme
      //                                   .onBackground),
      //                     ),
      //                     Text(
      //                       "⚈  8 minimum characters",
      //                       style: TextStyle(
      //                           color: contains8Length
      //                               ? const Color.fromARGB(
      //                                   255, 152, 255, 152)
      //                               : Theme.of(context)
      //                                   .colorScheme
      //                                   .onBackground),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(height: 10),
      //             SizedBox(
      //               width: MediaQuery.of(context).size.width * 0.9,
      //               child: MyTextField(
      //                   controller: nameController,
      //                   label: 'Name',
      //                   hintText: '',
      //                   obscureText: false,
      //                   keyboardType: TextInputType.name,
      //                   prefixIcon: const Icon(CupertinoIcons.person_fill),
      //                   validator: (val) {
      //                     if (val!.isEmpty) {
      //                       return 'Please fill in this field';
      //                     } else if (val.length > 30) {
      //                       return 'Name too long';
      //                     } else if (!nameRegExp.hasMatch(val)) {
      //                       return 'Invalid characters in name';
      //                     }
      //                     return null;
      //                   }),
      //             ),
      //             const SizedBox(height: 10),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.all(5.0),
      //                       child: Text(
      //                         "Gender",
      //                         style: TextStyle(
      //                           fontSize: 16,
      //                           //fontWeight: FontWeight.bold,
      //                           color: Theme.of(context)
      //                               .colorScheme
      //                               .onBackground,
      //                         ),
      //                       ),
      //                     ),
      //                     Container(
      //                       height: 55,
      //                       decoration: BoxDecoration(
      //                           color: Colors.grey.shade200,
      //                           borderRadius: BorderRadius.circular(10)),
      //                       child: Theme(
      //                         data: Theme.of(context).copyWith(
      //                           canvasColor: Theme.of(context)
      //                               .colorScheme
      //                               .onBackground,
      //                         ),
      //                         child: DropdownButton<String>(
      //                           underline: const SizedBox(),
      //                           value: selectedGender,
      //                           onChanged: (String? newValue) {
      //                             setState(() {
      //                               selectedGender = newValue;
      //                             });
      //                           },
      //                           items: possGenders
      //                               .map((Map<String, dynamic> gender) {
      //                             return DropdownMenuItem<String>(
      //                               value: gender["value"],
      //                               child: Row(
      //                                 children: <Widget>[
      //                                   Icon(gender["icon"]),
      //                                   const SizedBox(width: 8),
      //                                   Text(gender["label"]),
      //                                 ],
      //                               ),
      //                             );
      //                           }).toList(),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 SizedBox(
      //                   width: MediaQuery.of(context).size.width * 0.3,
      //                   child: MyTextField(
      //                     controller: ageController,
      //                     label: 'Age',
      //                     hintText: '',
      //                     obscureText: false,
      //                     keyboardType: TextInputType.number,
      //                     prefixIcon:
      //                         const Icon(Icons.face_retouching_natural),
      //                     validator: (val) {
      //                       if (val!.isEmpty) {
      //                         return 'Please fill in this field';
      //                       } else if (!ageRegExp.hasMatch(val)) {
      //                         return 'Please enter a valid age(1-99)';
      //                       }
      //                       return null;
      //                     },
      //                   ),
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(height: 10),
      //             SizedBox(
      //               width: MediaQuery.of(context).size.width * 0.9,
      //               child: MyTextField(
      //                 controller: gradeController,
      //                 label: 'Grade you climb comfortably',
      //                 hintText: '6b',
      //                 obscureText: false,
      //                 keyboardType: TextInputType.text,
      //                 prefixIcon: const Icon(Icons.trending_up),
      //                 validator: (val) {
      //                   if (val!.isEmpty) {
      //                     return 'Please fill in this field';
      //                   } else if (!boulderingGradeRegExp.hasMatch(val)) {
      //                     return 'Please enter a valid climbing grade';
      //                   }
      //                   return null;
      //                 },
      //               ),
      //             ),
      //             const SizedBox(height: 20),
      //             Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.all(5.0),
      //                   child: Text(
      //                     "Your Gym",
      //                     style: TextStyle(
      //                       fontSize: 16,
      //                       color:
      //                           Theme.of(context).colorScheme.onBackground,
      //                     ),
      //                   ),
      //                 ),
      //                 Stack(
      //                   children: [
      //                     Container(
      //                       height: 60,
      //                       decoration: BoxDecoration(
      //                           color: Colors.grey.shade200,
      //                           borderRadius: BorderRadius.circular(10)),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Theme(
      //                         data: Theme.of(context).copyWith(
      //                           canvasColor: Theme.of(context)
      //                               .colorScheme
      //                               .onBackground,
      //                         ),
      //                         child: DropdownButtonFormField(
      //                           validator: (value) {
      //                             if (value == null) {
      //                               return 'Please select a gym';
      //                             }
      //                             return null;
      //                           },
      //                           onChanged: (Gym? newValue) {
      //                             setState(() {
      //                               selectedGym = newValue;
      //                             });
      //                           },
      //                           items: gyms.map((Gym gym) {
      //                             return DropdownMenuItem<Gym>(
      //                               value: gym,
      //                               child: Text(gym.name),
      //                             );
      //                           }).toList(),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             ),
      //             // BlocBuilder<GetGymBloc, GetGymState>(
      //             //   builder: (context, gymState) {
      //             //     if (gymState is GetGymSuccess) {
      //             //       final gyms = gymState.gyms;
      //             //       return DropdownButtonFormField<Gym>(
      //             //         value: selectedGym,
      //             //         onChanged: (Gym? newValue) {
      //             //           setState(() {
      //             //             selectedGym = newValue;
      //             //           });
      //             //         },
      //             //         items: gyms.map((Gym gym) {
      //             //           return DropdownMenuItem<Gym>(
      //             //             value: gym,
      //             //             child: Text(gym.name),
      //             //           );
      //             //         }).toList(),
      //             //         decoration: const InputDecoration(
      //             //           labelText: 'Choose a gym',
      //             //           border: OutlineInputBorder(),
      //             //         ),
      //             //       );
      //             //     } else if (gymState is GetGymLoading) {
      //             //       return const CircularProgressIndicator();
      //             //     } else {
      //             //       return Text(
      //             //         "Failed to Retrieve Gyms",
      //             //         style: TextStyle(
      //             //           color: Theme.of(context).colorScheme.onBackground,
      //             //         ),
      //             //       );
      //             //     }
      //             //   },
      //             // ),
      //             const SizedBox(height: 20),
      //             SizedBox(
      //                 height: MediaQuery.of(context).size.height * 0.05),
      // !signUpRequired
      //     ? SizedBox(
      //         width: MediaQuery.of(context).size.width * 0.4,
      //         height: 50,
      //         child: TextButton(
      //             onPressed: () {
      //               if (_formKey.currentState!.validate()) {
      //                 MyUser myUser = MyUser.empty;
      //                 myUser = myUser.copyWith(
      //                   email: emailController.text,
      //                   name: nameController.text,
      //                   age: int.parse(ageController.text),
      //                   gender: selectedGender,
      //                   grade: gradeController.text,
      //                   gym: selectedGym,
      //                 );

      //                 setState(() {
      //                   context.read<SignUpBloc>().add(
      //                       SignUpRequired(myUser,
      //                           passwordController.text));
      //                 });
      //               }
      //             },
      //             style: TextButton.styleFrom(
      //                 elevation: 3.0,
      //                 backgroundColor:
      //                     Theme.of(context).colorScheme.primary,
      //                 foregroundColor: Colors.white,
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius:
      //                         BorderRadius.circular(60))),
      //             child: const Padding(
      //               padding: EdgeInsets.symmetric(
      //                   horizontal: 25, vertical: 5),
      //               child: Text(
      //                 'Sign Up',
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 16,
      //                     fontWeight: FontWeight.w600),
      //               ),
      //             )),
      //       )
      //     : const CircularProgressIndicator(),
      //             const SizedBox(height: 40),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      //],
      //),
    );
  }
}

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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

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
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
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
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            "⚈  1 lowercase",
                            style: TextStyle(
                                color: containsLowerCase
                                    ? const Color.fromARGB(255, 152, 255, 152)
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            "⚈  1 number",
                            style: TextStyle(
                                color: containsNumber
                                    ? const Color.fromARGB(255, 152, 255, 152)
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
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
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            "⚈  8 minimum characters",
                            style: TextStyle(
                                color: contains8Length
                                    ? const Color.fromARGB(255, 152, 255, 152)
                                    : Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                  const SizedBox(height: 10),
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
                      Stack(
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
                    ],
                  ),
                  // BlocBuilder<GetGymBloc, GetGymState>(
                  //   builder: (context, gymState) {
                  //     if (gymState is GetGymSuccess) {
                  //       final gyms = gymState.gyms;
                  //       return DropdownButtonFormField<Gym>(
                  //         value: selectedGym,
                  //         onChanged: (Gym? newValue) {
                  //           setState(() {
                  //             selectedGym = newValue;
                  //           });
                  //         },
                  //         items: gyms.map((Gym gym) {
                  //           return DropdownMenuItem<Gym>(
                  //             value: gym,
                  //             child: Text(gym.name),
                  //           );
                  //         }).toList(),
                  //         decoration: const InputDecoration(
                  //           labelText: 'Choose a gym',
                  //           border: OutlineInputBorder(),
                  //         ),
                  //       );
                  //     } else if (gymState is GetGymLoading) {
                  //       return const CircularProgressIndicator();
                  //     } else {
                  //       return Text(
                  //         "Failed to Retrieve Gyms",
                  //         style: TextStyle(
                  //           color: Theme.of(context).colorScheme.onBackground,
                  //         ),
                  //       );
                  //     }
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  !signUpRequired
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 50,
                          child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  MyUser myUser = MyUser.empty;
                                  myUser = myUser.copyWith(
                                    email: emailController.text,
                                    name: nameController.text,
                                    age: int.parse(ageController.text),
                                    gender: selectedGender,
                                    grade: gradeController.text,
                                    gym: selectedGym,
                                  );

                                  setState(() {
                                    context.read<SignUpBloc>().add(
                                        SignUpRequired(
                                            myUser, passwordController.text));
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        )
                      : const CircularProgressIndicator(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

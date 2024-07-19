import 'dart:developer';

import 'package:boulderbuds/app_view.dart';
import 'package:boulderbuds/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:boulderbuds/components/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:user_repository/user_repository.dart';
import '../../../components/strings.dart';

typedef OnFilterApplied = void Function(MyUser updatedUser);

class BuddyPreferencesEditWidgetDemo extends StatefulWidget {
  final MyUser myUser;
  final OnFilterApplied onFilterApplied;
  //final UserRepository userRepository;

  BuddyPreferencesEditWidgetDemo({
    Key? key,
    required this.myUser,
    required this.onFilterApplied,
    //required this.userRepository,
  }) : super(key: key);

  @override
  State<BuddyPreferencesEditWidgetDemo> createState() =>
      _BuddyPreferencesEditWidgetDemoState();
}

class _BuddyPreferencesEditWidgetDemoState
    extends State<BuddyPreferencesEditWidgetDemo> {
  final _formKey = GlobalKey<FormState>();

  bool isExpandedBuddyPrefs = false;

  List<ValueItem> selectedGendersBuddy = [];
  final MultiSelectController genderBuddyController = MultiSelectController();

  int? selectedGradeLow;
  int? selectedGradeHigh;
  List<int> grades = List.generate(9, (index) => index + 1);

  bool allAges = false;
  bool allGrades = false;

  final ageSearchLowController = TextEditingController();
  final ageSearchHighController = TextEditingController();

  List<ValueItem> buddyPreferenceGenders = <ValueItem>[
    const ValueItem(label: "All", value: "a"),
    const ValueItem(label: "Male", value: "m"),
    const ValueItem(label: "Female", value: "f"),
    const ValueItem(label: "Other", value: "u"),
  ];

  @override
  void initState() {
    super.initState();
    ageSearchLowController.text =
        widget.myUser.searchAgeLow == 0 || widget.myUser.searchAgeLow == null
            ? ""
            : widget.myUser.searchAgeLow.toString();
    ageSearchHighController.text =
        widget.myUser.searchAgeHigh == 0 || widget.myUser.searchAgeHigh == null
            ? ""
            : widget.myUser.searchAgeHigh.toString();
    List<ValueItem> searchGenderOptions;

    if (widget.myUser.searchGender?.contains("a") == true ||
        widget.myUser.searchGender == null) {
      // "a" (All) is aanwezig in de lijst
      searchGenderOptions = [buddyPreferenceGenders[0]];
    } else {
      // Voeg alle andere genders toe
      searchGenderOptions = widget.myUser.searchGender?.map((gender) {
            switch (gender) {
              case "m":
                return buddyPreferenceGenders[1];
              case "f":
                return buddyPreferenceGenders[2];
              case "u":
                return buddyPreferenceGenders[3];
              default:
                return ValueItem(label: gender, value: gender);
            }
          }).toList() ??
          [];
    }

    genderBuddyController.setOptions(buddyPreferenceGenders);
    genderBuddyController.setSelectedOptions(searchGenderOptions);
    selectedGradeLow =
        widget.myUser.searchGradeLow == 0 ? null : widget.myUser.searchGradeLow;
    selectedGradeHigh = widget.myUser.searchGradeHigh == 0
        ? null
        : widget.myUser.searchGradeHigh;

    // Controleer of searchAge beide 0 is
    if (widget.myUser.searchAgeLow == 0 && widget.myUser.searchAgeHigh == 0) {
      // Als beide 0 zijn, zet de switch voor leeftijd op true
      setState(() {
        allAges = true;
      });
    }

    // Controleer of searchGrade beide 0 zijn
    if (widget.myUser.searchGradeLow == 0 &&
        widget.myUser.searchGradeHigh == 0) {
      // Als beide 0 zijn, zet de switch voor grades op true
      setState(() {
        allGrades = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Buddy preferences',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 5, right: 5),
                      child: Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: MultiSelectDropDown(
                      controller: genderBuddyController,
                      selectionType: SelectionType.multi,
                      selectedOptions: selectedGendersBuddy,
                      onOptionSelected: (List<ValueItem> selectedOptions) {
                        setState(() {
                          if (selectedOptions.length > 1 &&
                              selectedOptions
                                  .any((item) => item.value == "a")) {
                            // "All" is samen met andere opties geselecteerd
                            log("All is selected");
                            genderBuddyController.clearAllSelection();
                            genderBuddyController.addSelectedOption(
                                const ValueItem(label: "All", value: "a"));
                            selectedGendersBuddy =
                                genderBuddyController.options;
                          } else if (!selectedOptions
                              .any((item) => item.value == "a")) {
                            // Andere opties zijn geselecteerd
                            selectedGendersBuddy = selectedOptions
                                .where((item) => item.value != "a")
                                .toList();
                            log("Multiple items selected");
                          }
                          log(selectedOptions.toString());
                        });
                      },
                      options: buddyPreferenceGenders,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "All ages",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(
                          height: 55,
                          width: 80,
                          child: Switch(
                            value: allAges,
                            onChanged: (value) {
                              setState(() {
                                allAges = value;
                                if (value) {
                                  ageSearchLowController.text = '';
                                  ageSearchHighController.text = '';
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.22,
                        child: MyTextField(
                          controller: ageSearchLowController,
                          enabled: !allAges,
                          label: 'Age Range',
                          hintText: '17',
                          obscureText: false,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.expand_more),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return null;
                            } else if (!ageRegExp.hasMatch(val)) {
                              return 'Please enter a valid age(1-99)';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                    )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.22,
                      child: MyTextField(
                        controller: ageSearchHighController,
                        enabled: !allAges,
                        label: '',
                        hintText: '22',
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(Icons.expand_less),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return null;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "All grades",
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(
                          height: 55,
                          width: 80,
                          child: Switch(
                            value: allGrades,
                            onChanged: (value) {
                              setState(() {
                                allGrades = value;
                                if (value) {
                                  selectedGradeLow = null;
                                  selectedGradeHigh = null;
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, right: 5, bottom: 5),
                            child: Text(
                              "Lowest Grade",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                          Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.1),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                child: DropdownButton<int>(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  value: selectedGradeLow,
                                  onChanged: !allGrades
                                      ? (int? newValue) {
                                          setState(() {
                                            selectedGradeLow = newValue;
                                          });
                                        }
                                      : null,
                                  items: grades.map((int grade) {
                                    return DropdownMenuItem<int>(
                                      value: grade,
                                      child: Text(grade.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Highest Grade",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.1),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                                child: DropdownButton<int>(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  value: selectedGradeHigh,
                                  onChanged: !allGrades
                                      ? (int? newValue) {
                                          setState(() {
                                            selectedGradeHigh = newValue;
                                          });
                                        }
                                      : null,
                                  items: grades.map((int grade) {
                                    return DropdownMenuItem<int>(
                                      value: grade,
                                      child: Text(grade.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Validatie voor leeftijdsvelden
                          if (ageSearchLowController.text.isNotEmpty &&
                              !ageRegExp
                                  .hasMatch(ageSearchLowController.text)) {
                            return;
                          }

                          if (ageSearchHighController.text.isNotEmpty &&
                              !ageRegExp
                                  .hasMatch(ageSearchHighController.text)) {
                            return;
                          }

                          // Validatie en toewijzing voor grade velden
                          if (selectedGradeLow == null ||
                              selectedGradeHigh == null) {
                            selectedGradeLow = 0;
                            selectedGradeHigh = 0;
                          } else if (selectedGradeLow! >= selectedGradeHigh!) {
                            // Toon een foutmelding als selectedGradeLow groter of gelijk is aan selectedGradeHigh
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Lowest Grade should be less than Highest Grade')),
                            );
                            return;
                          }

                          List<String>? searchGender =
                              selectedGendersBuddy.isEmpty
                                  ? null
                                  : selectedGendersBuddy
                                      .map<String>((item) => item.value)
                                      .toList();
                          MyUser updatedUser = widget.myUser.copyWith(
                            searchGender: searchGender,
                            searchGradeLow:
                                allGrades ? 0 : selectedGradeLow ?? 0,
                            searchGradeHigh:
                                allGrades ? 0 : selectedGradeHigh ?? 0,
                            searchAgeLow: allAges
                                ? 0
                                : (ageSearchLowController.text.isNotEmpty
                                    ? int.parse(ageSearchLowController.text)
                                    : 0),
                            searchAgeHigh: allAges
                                ? 0
                                : (ageSearchHighController.text.isNotEmpty
                                    ? int.parse(ageSearchHighController.text)
                                    : 0),
                          );

                          widget.onFilterApplied(updatedUser);

                          Navigator.pop(context);
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: Text(
                          'Filter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

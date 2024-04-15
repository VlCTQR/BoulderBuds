import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class BuddyPreferencesWidget extends StatelessWidget {
  final MyUser myUser;

  const BuddyPreferencesWidget({Key? key, required this.myUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, bottom: 3, top: 3, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gender",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                if (myUser.searchGender != null &&
                    myUser.searchGender!.isNotEmpty &&
                    !myUser.searchGender!.contains("a"))
                  Row(
                    children: myUser.searchGender!.map((gender) {
                      IconData iconData;
                      switch (gender) {
                        case "m":
                          iconData = Icons.male;
                          break;
                        case "f":
                          iconData = Icons.female;
                          break;
                        default:
                          iconData = Icons.transgender;
                          break;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Icon(
                          iconData,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      );
                    }).toList(),
                  ),
                if (myUser.searchGender == null ||
                    myUser.searchGender!.isEmpty ||
                    myUser.searchGender!.contains("a"))
                  Text(
                    "All genders",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 3,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 5, bottom: 3, top: 3, right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Age",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                if (myUser.searchAgeLow != null &&
                    myUser.searchAgeHigh != null &&
                    myUser.searchAgeLow != 0 &&
                    myUser.searchAgeHigh != 0)
                  Text(
                    "${myUser.searchAgeLow} - ${myUser.searchAgeHigh}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                if (myUser.searchAgeLow == null ||
                    myUser.searchAgeHigh == null ||
                    myUser.searchAgeLow == 0 && myUser.searchAgeHigh == 0)
                  Text(
                    "All ages",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 3,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 5, bottom: 3, top: 3, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Grade",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                Text(
                  myUser.searchGradeLow == null ||
                          myUser.searchGradeLow == 0 &&
                              myUser.searchGradeHigh == null ||
                          myUser.searchGradeHigh == 0
                      ? "All grades"
                      : "${myUser.searchGradeLow}a - ${myUser.searchGradeHigh}c",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

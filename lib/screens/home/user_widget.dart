import 'dart:developer';

import 'package:boulderbuds/screens/user/user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class UserWidget extends StatelessWidget {
  final MyUser myUser;

  const UserWidget({Key? key, required this.myUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => UserScreen(myUser: myUser)),
        );
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (myUser.picture != "")
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        myUser.picture!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (myUser.picture == "")
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.grey.shade600,
                    size: 50,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        myUser.gender == "m"
                            ? Icons.male
                            : myUser.gender == "f"
                                ? Icons.female
                                : Icons.transgender,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${myUser.name.split(' ')[0].length > 10 ? myUser.name.split(' ')[0].substring(0, 10) + '...' : myUser.name.split(' ')[0]}, ${myUser.age ?? "-"}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "  ·  ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        myUser.grade ?? "0",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  //const SizedBox(height: 5),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Wants to climb with:"),
                            Row(
                              children: [
                                const Icon(Icons.unfold_more),
                                if (myUser.searchAgeLow != null &&
                                    myUser.searchAgeHigh != null &&
                                    myUser.searchAgeLow != 0 &&
                                    myUser.searchAgeHigh != 0)
                                  Text(
                                      ": ${myUser.searchAgeLow} - ${myUser.searchAgeHigh}"),
                                if (myUser.searchAgeLow == null ||
                                    myUser.searchAgeHigh == null ||
                                    myUser.searchAgeLow == 0 &&
                                        myUser.searchAgeHigh == 0)
                                  const Text(": All ages"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.person),
                                const Text(": "),
                                if (myUser.searchGender != null &&
                                    myUser.searchGender!.isNotEmpty &&
                                    !myUser.searchGender!.contains("a"))
                                  for (String gender in myUser.searchGender!)
                                    Row(
                                      children: [
                                        Icon(
                                          gender == "m"
                                              ? Icons.male
                                              : (gender == "f"
                                                  ? Icons.female
                                                  : Icons.transgender),
                                        ),
                                      ],
                                    ),
                                if (myUser.searchGender == null ||
                                    myUser.searchGender!.isEmpty ||
                                    myUser.searchGender!.contains("a"))
                                  const Text("All genders"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.trending_up),
                                Text(myUser.searchGradeLow == null ||
                                        myUser.searchGradeLow == 0 &&
                                            myUser.searchGradeHigh == null ||
                                        myUser.searchGradeHigh == 0
                                    ? ": All grades"
                                    : ":  ${myUser.searchGradeLow}a - ${myUser.searchGradeHigh}c"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:boulderbuds/app_view.dart';
import 'package:boulderbuds/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:boulderbuds/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:boulderbuds/components/gyms_data.dart';
import 'package:boulderbuds/components/textfield.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_repository/gym_repository.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart';
import '../../components/strings.dart';

class AccountSetupScreen extends StatefulWidget {
  final String title;
  final MyUser myUser;
  final UserRepository userRepository;

  AccountSetupScreen({
    Key? key,
    required this.title,
    required this.myUser,
    required this.userRepository,
  }) : super(key: key);

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final ageController = TextEditingController();

  final gradeController = TextEditingController();

  String? selectedGender = "m";
  List<Map<String, dynamic>> possGenders = [
    {"value": "m", "label": "Male", "icon": Icons.male},
    {"value": "f", "label": "Female", "icon": Icons.female},
    {"value": "u", "label": "Other", "icon": Icons.transgender},
  ];

  Gym? selectedGym;

  List<Gym> gyms = GymsData.gyms;

  final descriptionController = TextEditingController();

  bool inGhostMode = false;

  final instagramController = TextEditingController();
  final facebookController = TextEditingController();
  final twitterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.myUser.name;
    ageController.text = widget.myUser.age.toString();
    gradeController.text = widget.myUser.grade ?? "";
    selectedGender = widget.myUser.gender;
    selectedGym = widget.myUser.gym;
    descriptionController.text = widget.myUser.description ?? "";
    instagramController.text = widget.myUser.instagram ?? "";
    facebookController.text = widget.myUser.facebook ?? "";
    twitterController.text = widget.myUser.twitter ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyAppView(),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          centerTitle: false,
          title: Text(
            widget.title,
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<SignInBloc>().add(const SignOutRequired());
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(
                    "Log Out",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Icon(
                    CupertinoIcons.square_arrow_right,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ],
              ),
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) =>
              UpdateUserInfoBloc(userRepository: widget.userRepository),
          child: BlocBuilder<UpdateUserInfoBloc, UpdateUserInfoState>(
            builder: (context, state) {
              if (state is UploadPictureSuccess) {
                String imageUrl = state.userImage;
                widget.myUser.picture = imageUrl;
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
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
                            GestureDetector(
                              onTap: () async {
                                if (!kIsWeb) {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 500,
                                    maxWidth: 500,
                                    imageQuality: 40,
                                  );
                                  if (image != null) {
                                    CroppedFile? croppedFile =
                                        await ImageCropper().cropImage(
                                      sourcePath: image.path,
                                      aspectRatio: const CropAspectRatio(
                                          ratioX: 1, ratioY: 1),
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.square
                                      ],
                                      uiSettings: [
                                        AndroidUiSettings(
                                            toolbarTitle: 'Cropper',
                                            toolbarColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio:
                                                CropAspectRatioPreset.original,
                                            lockAspectRatio: false),
                                        IOSUiSettings(
                                          title: 'Cropper',
                                        ),
                                        WebUiSettings(
                                          context: context,
                                          customDialogBuilder:
                                              (cropper, crop, rotate) {
                                            return Dialog(
                                              child: Builder(
                                                builder: (context) {
                                                  return Column(children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.7,
                                                      child: cropper,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        /// it is important to call crop() function and return
                                                        /// result data to plugin, for example:
                                                        final result =
                                                            await crop();
                                                        Navigator.of(context)
                                                            .pop(result);
                                                      },
                                                      child: const Text('Crop'),
                                                    )
                                                  ]);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                    if (croppedFile != null) {
                                      setState(() {
                                        context
                                            .read<UpdateUserInfoBloc>()
                                            .add(UploadPicture(
                                              croppedFile.path,
                                              widget.myUser.id,
                                            ));
                                      });
                                    }
                                  }
                                } else if (kIsWeb) {
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 500,
                                    maxWidth: 500,
                                    imageQuality: 40,
                                  );
                                  if (image != null) {
                                    setState(() {
                                      context.read<UpdateUserInfoBloc>().add(
                                          UploadPictureWeb(
                                              image, widget.myUser.id));
                                    });
                                  }
                                }
                              },
                              child: widget.myUser.picture == ""
                                  ? Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade300,
                                      ),
                                      child: Icon(
                                        CupertinoIcons.pencil,
                                        color: Colors.grey[800],
                                        size: 100,
                                      ),
                                    )
                                  : Container(
                                      width: 200,
                                      height: 200,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade300,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            widget.myUser.picture!,
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                            Colors.grey.withOpacity(0.5),
                                            BlendMode.dstATop,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.pencil,
                                        color: Colors.grey[800],
                                        size: 100,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: MyTextField(
                                  controller: nameController,
                                  hintText: "",
                                  obscureText: false,
                                  keyboardType: TextInputType.name,
                                  label: "Name",
                                  prefixIcon:
                                      const Icon(CupertinoIcons.person_fill),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                        child: DropdownButton<String>(
                                          underline: const SizedBox(),
                                          value: selectedGender,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedGender = newValue;
                                            });
                                          },
                                          items: possGenders.map(
                                              (Map<String, dynamic> gender) {
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: MyTextField(
                                    controller: ageController,
                                    label: 'Age',
                                    hintText: '',
                                    obscureText: false,
                                    keyboardType: TextInputType.number,
                                    prefixIcon: const Icon(
                                        Icons.face_retouching_natural),
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
                                  } else if (!boulderingGradeRegExp
                                      .hasMatch(val)) {
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
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
                              ],
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Description cannot be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Ghost Mode makes your profile invisible",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 16,
                                        //fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 50,
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    inGhostMode = !inGhostMode;
                                  });
                                },
                                style: TextButton.styleFrom(
                                    elevation: 3.0,
                                    backgroundColor: inGhostMode
                                        ? Colors.white
                                        : Colors.grey.withOpacity(0.5),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60))),
                                icon: Icon(inGhostMode
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                label: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: Text(
                                    'Ghost Mode',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
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
                                          !instagramUsernameRegExp
                                              .hasMatch(value)) {
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
                                          !facebookUsernameRegExp
                                              .hasMatch(value)) {
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
                                          !twitterUsernameRegExp
                                              .hasMatch(value)) {
                                        return 'Invalid Twitter handle';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        MyUser myUser = widget.myUser.copyWith(
                                          name: nameController.text,
                                          age: int.parse(ageController.text),
                                          gender: selectedGender,
                                          grade: gradeController.text,
                                          gym: selectedGym,
                                          description:
                                              descriptionController.text,
                                          instagram: instagramController.text,
                                          facebook: facebookController.text,
                                          twitter: twitterController.text,
                                        );

                                        context
                                            .read<UpdateUserInfoBloc>()
                                            .add(UpdateUserInfo(myUser));

                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MyAppView(),
                                          ),
                                        );
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 5),
                                      child: Text(
                                        'Save Info',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () async {
                                        bool? confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              title:
                                                  const Text('Delete Account'),
                                              content: const Text(
                                                  'Deleting your account will result in all your user data loss.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: const Text(
                                                      'I want to delete',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .redAccent)),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true) {
                                          bool? secondConfirm =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: const Text(
                                                    'Confirm Deletion'),
                                                content: const Text(
                                                    'Are you sure you want to delete your account? This action cannot be undone.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (secondConfirm == true) {
                                            context
                                                .read<UpdateUserInfoBloc>()
                                                .add(DeleteUser(widget.myUser));
                                            context
                                                .read<SignInBloc>()
                                                .add(const SignOutRequired());
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        elevation: 3.0,
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        child: Icon(Icons.delete_outline),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

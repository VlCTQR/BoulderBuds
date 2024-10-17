import 'package:boulderbuds/app_view.dart';
import 'package:boulderbuds/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UserScreen extends StatefulWidget {
  final MyUser myUser;
  final MyUser currentUser;
  final UserRepository userRepository;

  const UserScreen(
      {Key? key,
      required this.myUser,
      required this.userRepository,
      required this.currentUser})
      : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isBuddy = false;
  bool outgoingRequest = false;
  bool incomingRequest = false;

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkBuddyAndRequestStatus();
  }

  Future<void> _checkBuddyAndRequestStatus() async {
    try {
      // Fetch buddies, outgoing and request collections from the repository
      List<String> buddies = widget.currentUser.buddies ?? [];
      List<String> outgoingRequests = widget.currentUser.outgoing ?? [];
      List<String> incomingRequests = widget.currentUser.incoming ?? [];

      // Check if myUser is in buddies or outgoing requests
      setState(() {
        isBuddy = buddies.contains(widget.myUser.id);
        outgoingRequest = outgoingRequests.contains(widget.myUser.id);
        incomingRequest = incomingRequests.contains(widget.myUser.id);
      });
    } catch (e) {
      // Handle any errors that might occur during data fetch
      debugPrint('Error checking buddy/request status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.onBackground,
          centerTitle: true,
          title: Text(
            widget.myUser.name,
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 50),
                widget.myUser.picture == ""
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.grey[800],
                          size: 80,
                        ),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.myUser.picture!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Text(
                  widget.myUser.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          //fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Text(
                        widget.myUser.description ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (incomingRequest) const SizedBox(height: 20),
                if (incomingRequest)
                  TextButton(
                    onPressed: () {
                      bool canBeBuddy = false;

                      // Get current list of incoming requests of current user
                      List<String> incomingRequests =
                          widget.currentUser.incoming ?? [];

                      // Check if the incoming requests of current user contains user
                      if (incomingRequests.contains(widget.myUser.id)) {
                        canBeBuddy = true;
                      }

                      // Get current list of outgoing requests of user
                      List<String> outgoingRequests =
                          widget.myUser.outgoing ?? [];

                      // Check if the outgoing requests of user contains current user
                      if (outgoingRequests.contains(widget.currentUser.id)) {
                      } else {
                        canBeBuddy = false;
                      }

                      // Get current list of buddies of current user
                      List<String> buddiesCurrentUser =
                          widget.currentUser.buddies ?? [];

                      // Get current list of buddies of user
                      List<String> buddiesOtherUser =
                          widget.myUser.buddies ?? [];

                      if (canBeBuddy) {
                        // Add the user to the buddies list of the current user
                        if (!buddiesCurrentUser.contains(widget.myUser.id)) {
                          context.read<UpdateUserInfoBloc>().add(
                              AddBuddy(widget.currentUser, widget.myUser.id));
                        }

                        // Add the current user to the buddies list of the user
                        if (!buddiesOtherUser.contains(widget.currentUser.id)) {
                          context.read<UpdateUserInfoBloc>().add(
                              AddBuddy(widget.myUser, widget.currentUser.id));
                        }

                        // Remove the incoming request from current user to user
                        context.read<UpdateUserInfoBloc>().add(
                            RemoveIncomingRequest(
                                widget.currentUser, widget.myUser.id));

                        // Remove the outgoing request of current user to user
                        context.read<UpdateUserInfoBloc>().add(
                            RemoveOutgoingRequest(
                                widget.myUser, widget.currentUser.id));
                      }

                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyAppView(homeScreenPageIndex: 1),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      child: Text(
                        'Accept Buddy!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (!outgoingRequest && !isBuddy && !incomingRequest)
                  const SizedBox(height: 20),
                if (!outgoingRequest && !isBuddy && !incomingRequest)
                  TextButton(
                    onPressed: () {
                      // Get current list of incoming requests of user
                      List<String> incomingRequests =
                          widget.myUser.incoming ?? [];

                      // Check if incoming requests list doesn't already contain current user
                      if (!incomingRequests.contains(widget.currentUser.id)) {
                        // Add current user to list of incoming requests of user
                        context.read<UpdateUserInfoBloc>().add(
                            AddIncomingRequest(
                                widget.myUser, widget.currentUser.id));
                      }

                      // Get current list of outgoing requests of current user
                      List<String> outgoingUpdated =
                          widget.currentUser.outgoing ?? [];

                      // Check if outgoing requests list doesn't already contain user
                      if (!outgoingUpdated.contains(widget.myUser.id)) {
                        // Add user to list of outgoing requests of current user
                        context.read<UpdateUserInfoBloc>().add(
                            AddOutgoingRequest(
                                widget.currentUser, widget.myUser.id));
                      }
                    },
                    style: TextButton.styleFrom(
                      elevation: 3.0,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      child: Text(
                        'Send invite to Climb',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (widget.myUser.instagram != null &&
                    widget.myUser.instagram != "" &&
                    isBuddy)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _launchUrl(Uri.parse(
                          "https://instagram.com/${widget.myUser.instagram!}/")),
                      // onTap: () => showModalBottomSheet(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return InAppWebView(
                      //       initialUrlRequest: URLRequest(
                      //         url: WebUri.uri(
                      //           Uri.parse(
                      //               "https://www.instagram.com/${myUser.instagram!}/"),
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "@${widget.myUser.instagram!}",
                                  style: const TextStyle(
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
                if (widget.myUser.facebook != null &&
                    widget.myUser.facebook != "" &&
                    isBuddy)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _launchUrl(Uri.parse(
                          "https://facebook.com/${widget.myUser.facebook!}/")),
                      // onTap: () => showModalBottomSheet(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return InAppWebView(
                      //       initialUrlRequest: URLRequest(
                      //         url: WebUri.uri(Uri.parse(
                      //             "https://www.facebook.com/${myUser.facebook!}/")),
                      //       ),
                      //     );
                      //   },
                      // ),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "@${widget.myUser.facebook!}",
                                  style: const TextStyle(
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
                if (widget.myUser.twitter != null &&
                    widget.myUser.twitter != "" &&
                    isBuddy)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _launchUrl(Uri.parse(
                          "https://twitter.com/${widget.myUser.twitter!}/")),
                      // onTap: () => showModalBottomSheet(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return InAppWebView(
                      //       initialUrlRequest: URLRequest(
                      //         url: WebUri.uri(Uri.parse(
                      //             "https://www.twitter.com/${myUser.twitter!}/")),
                      //       ),
                      //     );
                      //   },
                      // ),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "@${widget.myUser.twitter!}",
                                  style: const TextStyle(
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
                  )
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UserScreen extends StatelessWidget {
  final MyUser myUser;

  const UserScreen({Key? key, required this.myUser}) : super(key: key);

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
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
            myUser.name,
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
                myUser.picture == ""
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
                              myUser.picture!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                Text(
                  myUser.name,
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
                        myUser.description ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (myUser.instagram != null && myUser.instagram != "")
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _launchUrl(Uri.parse(
                          "https://instagram.com/${myUser.instagram!}/")),
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
                                  "@${myUser.instagram!}",
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
                if (myUser.facebook != null && myUser.facebook != "")
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _launchUrl(Uri.parse(
                          "https://facebook.com/${myUser.facebook!}/")),
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
                                  "@${myUser.facebook!}",
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
                if (myUser.twitter != null && myUser.twitter != "")
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _launchUrl(
                          Uri.parse("https://twitter.com/${myUser.twitter!}/")),
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
                                  "@${myUser.twitter!}",
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../widgets/user_image_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, //It should be false to work
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }
        await _onBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          title: const Text(
            StringConstants.appName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 230.0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10.0),
                      const UserImageWidget(
                        imageUrl:
                            "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1",
                        title: "User Name",
                        size: 120,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "User Name",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.theWhite,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // ListTile(
                //   leading: const Icon(Icons.download),
                //   title: Text(
                //     StringConstants.downloads,
                //     style: const TextStyle(
                //       fontSize: 18.0,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   trailing: const Icon(
                //     Icons.arrow_forward_ios,
                //     size: 16.0,
                //   ),
                //   onTap: () {
                //   },
                // ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    StringConstants.logout,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            StringConstants.confirm,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: const Text(StringConstants.doYouWantToExitTheApp),
          actions: <Widget>[
            TextButton(
              child: const Text(
                StringConstants.no,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //Will not exit the App
              },
            ),
            TextButton(
              child: const Text(
                StringConstants.yes,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                SystemNavigator.pop();
                Navigator.of(context).pop(); //Will exit the App
              },
            )
          ],
        );
      },
    );
  }
}

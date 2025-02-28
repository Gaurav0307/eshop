import 'package:eshop/common/constants/color_constants.dart';
import 'package:eshop/views/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/constants/string_constants.dart';

class ProfileAndSettingsScreen extends StatefulWidget {
  const ProfileAndSettingsScreen({super.key});

  @override
  State<ProfileAndSettingsScreen> createState() =>
      _ProfileAndSettingsScreenState();
}

class _ProfileAndSettingsScreenState extends State<ProfileAndSettingsScreen> {
  bool isCallEnabled = false;
  bool isMessageEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.profileAndSettings,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: ColorConstants.black,
            ),
            title: const Text(
              StringConstants.profile,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
            ),
            onTap: () {
              Get.to(() => const ProfileScreen());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: ColorConstants.black,
            ),
            title: const Text(
              StringConstants.call,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Switch(
              activeColor: Colors.green,
              value: isCallEnabled,
              onChanged: (isEnabled) {
                setState(() {
                  isCallEnabled = isEnabled;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.message,
              color: ColorConstants.black,
            ),
            title: const Text(
              StringConstants.message,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: CupertinoSwitch(
              activeColor: Colors.green,
              value: isMessageEnabled,
              onChanged: (isEnabled) {
                setState(() {
                  isMessageEnabled = isEnabled;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

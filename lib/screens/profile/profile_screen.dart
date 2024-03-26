import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../change_password/change_password_screen.dart';
import '../help/help_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';
import 'profile_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () =>
                  {Navigator.pushNamed(context, DetailProfileScreen.routeName)},
            ),
            ProfileMenu(
              text: "Change Password",
              icon: "assets/icons/Lock.svg",
              press: () => {
                Navigator.pushNamed(context, ChangePasswordScreen.routeName)
              },
            ),
            // ProfileMenu(
            //   text: "Notifications",
            //   icon: "assets/icons/Bell.svg",
            //   press: () {},
            // ),
            // ProfileMenu(
            //   text: "Settings",
            //   icon: "assets/icons/Settings.svg",
            //   press: () {},
            // ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {
                Navigator.pushNamed(context, HelpScreen.routeName);
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Hydai',
        ),
        content: const SizedBox(
          width: 150,
          height: 40,
          child: Center(child: Text('Sign Out ?')),
        ),
        actions: [
          SizedBox(
            width: 80,
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              onPressed: () => Navigator.pop(context, 'No'),
              child: const Text('No'),
            ),
          ),
          SizedBox(
            width: 80,
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => {_deleteAll(), SystemNavigator.pop()},
              child: const Text('Yes'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAll() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('id_user');
    localStorage.remove('name');
    localStorage.remove('mobile');
    localStorage.remove('email');
    localStorage.remove('street');
    localStorage.remove('street2');
    localStorage.remove('user_pass');
    localStorage.remove('user_name');
  }
}

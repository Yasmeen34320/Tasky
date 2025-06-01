import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/components/custom_text_field.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/main_screen.dart';
import 'package:tasky/services/preferences_manager.dart';
import 'package:tasky/tasks_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 52),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/logo.svg'),
                    SizedBox(width: 16),
                    Text(
                      'Tasky',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(fontSize: 28, letterSpacing: 0.5),
                    ),
                  ],
                ),
                SizedBox(height: 108),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome To Tasky',
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(letterSpacing: 2),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/images/hand.svg',
                      width: 28,
                      height: 28,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Your productivity journey starts here.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                SizedBox(height: 24),
                SvgPicture.asset(
                  'assets/images/pana.svg',
                  width: 215,
                  height: 204,
                ),
                SizedBox(height: 28),
                CustomTextField(
                  title: 'Full Name',
                  hintText: 'e.g. Sarah Khalid',
                  controller: _usernameController,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return ' Please Enter Your Name';
                    }
                    return null;
                  },
                ),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     'Full Name',
                //     style: Theme.of(context).textTheme.displaySmall,
                //     textAlign: TextAlign.left,
                //   ),
                // ),
                // SizedBox(height: 8),
                // TextField(
                //   style: TextStyle(color: Colors.white),
                //   cursorColor: Colors.white,
                //   decoration: InputDecoration(hintText: 'e.g. Sarah Khalid'),
                // ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width, 40),
                    ), // width:200, height:50
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // final SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // await prefs.setString(
                      //   'username',
                      //   _usernameController.text,
                      // );
                      PreferencesManager().setString(
                        StorageKey.username,
                        _usernameController.text,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return MainScreen();
                          },
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Let'
                      's Get Started',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

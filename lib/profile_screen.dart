import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/controllers/profile_controller.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/services/preferences_manager.dart';
import 'package:tasky/theme/theme_controller.dart';
import 'package:tasky/user_details.dart';
import 'package:tasky/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final profilecontroller = context.read<ProfileController>()..init();

    return Consumer<TaskController>(
      builder:
          (BuildContext context, TaskController controller, Widget? child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 52),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'assets/images/arrow.svg',
                          width: 30,
                          height: 30,
                          color: ThemeController.isDark()
                              ? Colors.white
                              : Color(0xFF3A4640),
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'My Profile',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                  SizedBox(height: 38),

                  Stack(
                    children: [
                      Selector<ProfileController, String?>(
                        selector: (context, ProfileController controller1) =>
                            controller1.userImagePath,
                        builder:
                            (
                              BuildContext context,
                              String? userImagePath,
                              Widget? child,
                            ) {
                              return CircleAvatar(
                                radius: 82,
                                backgroundColor: ThemeController.isDark()
                                    ? Color(0xFF181818)
                                    : Color(0xFFFFFFFF),

                                backgroundImage: userImagePath == null
                                    ? AssetImage('assets/images/avatar.png')
                                    : FileImage(File(userImagePath)),
                              );
                            },
                      ),
                      Positioned(
                        bottom: -5,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            showImageSourceDialog(context, (XFile file) {
                              _saveImage(file);
                              context.read<ProfileController>().changeImagePath(
                                file,
                              );

                              // userImagePath = file.path;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: ThemeController.isDark()
                                  ? Color(0xFF282828)
                                  : Color(0xFFFFFFFF),
                              child: SvgPicture.asset(
                                'assets/images/camera-01.svg',
                                width: 23,
                                height: 23,
                                color: ThemeController.isDark()
                                    ? Colors.white
                                    : Color(0xFF3A4640),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Selector<ProfileController, String?>(
                    selector: (context, ProfileController controller1) =>
                        controller1.username,
                    builder:
                        (
                          BuildContext context,
                          String? username,
                          Widget? child,
                        ) {
                          return Text(
                            username ?? "",
                            style: Theme.of(context).textTheme.displayMedium,
                          );
                        },
                  ),
                  SizedBox(height: 6),
                  Selector<ProfileController, String?>(
                    selector: (context, ProfileController controller1) =>
                        controller1.motivationQuote,
                    builder:
                        (
                          BuildContext context,
                          String? motivationQuote,
                          Widget? child,
                        ) {
                          return Text(
                            motivationQuote ??
                                "One task at a time. One step closer.",
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: ThemeController.isDark()
                                      ? Color(0xFFC6C6C6)
                                      : Color(0xFF6A6A6A),
                                  fontWeight: FontWeight.normal,
                                ),
                          );
                        },
                  ),
                  SizedBox(height: 44),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Profile Info',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/profile.svg',
                        width: 30,
                        height: 30,
                        color: ThemeController.isDark()
                            ? Colors.white
                            : Color(0xFF3A4640),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'User Details',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(fontSize: 20),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final bool? result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return UserDetails();
                              },
                            ),
                          );
                          if (result != null && result) {
                            context.read<ProfileController>().loadUserData();
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/images/Trailing element.svg',
                          width: 30,
                          height: 30,
                          color: ThemeController.isDark()
                              ? Colors.white
                              : Color(0xFF3A4640),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/moon-01.svg',
                        width: 30,
                        height: 30,
                        color: ThemeController.isDark()
                            ? Colors.white
                            : Color(0xFF3A4640),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Dark Mode',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(fontSize: 20),
                      ),
                      Spacer(),
                      ValueListenableBuilder(
                        valueListenable: ThemeController.themeNotifier,
                        builder: (BuildContext context, value, Widget? child) {
                          return Switch(
                            value: value == ThemeMode.dark,
                            onChanged: (bool value) async {
                              ThemeController.toggleTheme();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/Leading element.svg',
                        width: 30,
                        height: 30,
                        color: ThemeController.isDark()
                            ? Colors.white
                            : Color(0xFF3A4640),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Log Out',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(fontSize: 20),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await PreferencesManager().clear();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return WelcomeScreen();
                              },
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/images/Trailing element.svg',
                          width: 30,
                          height: 30,
                          color: ThemeController.isDark()
                              ? Colors.white
                              : Color(0xFF3A4640),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
    );
  }

  void _saveImage(XFile file) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = await File(file.path).copy('${appDir.path}/${file.name}');
    // PreferencesManager().setString(StorageKey.userImage, newFile.path);
  }
}

void showImageSourceDialog(BuildContext context, Function(XFile) selectedFile) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(
          'Choose Image Source',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 8),
                Text('Camera'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () async {
              Navigator.pop(context);
              XFile? image = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (image != null) {
                selectedFile(image);
              }
            },
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 8),
                Text('Gallery'),
              ],
            ),
          ),
        ],
      );
    },
  );
}

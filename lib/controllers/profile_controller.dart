import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/services/preferences_manager.dart';

class ProfileController with ChangeNotifier {
  String? username = "Default";
  String? userImagePath;
  String? motivationQuote = "One task at a time. One step closer.";

  init() {
    loadUserData();
  }

  void loadUserData() async {
    username = PreferencesManager().getString(StorageKey.username);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    motivationQuote = PreferencesManager().getString(
      StorageKey.motivationQuote,
    );
    print('from load  $username   $motivationQuote');
    notifyListeners();
  }

  changeImagePath(XFile file) {
    PreferencesManager().setString(StorageKey.userImage, file.path);
    userImagePath = file.path;
    notifyListeners();
  }

  changeDetails(String user, String motivation) async {
    username = user;
    motivationQuote = motivation;
    print('username $username , motivation $motivation');
    await PreferencesManager().setString(
      StorageKey.motivationQuote,
      motivation,
    );
    await PreferencesManager().setString(StorageKey.username, user);

    notifyListeners();
  }
}

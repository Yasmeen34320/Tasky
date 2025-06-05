import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/components/custom_text_field.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/controllers/profile_controller.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/services/preferences_manager.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  String? username, motivationQuote;
  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString(StorageKey.username);
    motivationQuote = prefs.getString(StorageKey.motivationQuote);
  }

  final TextEditingController userNameController = TextEditingController(
    text: PreferencesManager().getString(StorageKey.username),
  );
  final TextEditingController motivationQuoteController = TextEditingController(
    text: PreferencesManager().getString(StorageKey.motivationQuote),
  );

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'User Details',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
              SizedBox(height: 38),
              CustomTextField(
                title: 'Username',
                hintText: username ?? "",
                controller: userNameController,
              ),
              SizedBox(height: 16),
              CustomTextField(
                title: 'Motivation Quote',
                hintText:
                    motivationQuote ?? 'One task at a time. One step closer.',
                controller: motivationQuoteController,
                maxLines: 5,
              ),
              Spacer(),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    Size(MediaQuery.of(context).size.width, 40),
                  ), // width:200, height:50
                ),
                onPressed: () async {
                  await context.read<ProfileController>().changeDetails(
                    userNameController.text,
                    motivationQuoteController.text,
                  );
                  // await PreferencesManager().setString(
                  //   StorageKey.username,
                  //   userNameController.text,
                  // );
                  // await PreferencesManager().setString(
                  //   StorageKey.motivationQuote,
                  //   motivationQuoteController.text,
                  // );
                  motivationQuoteController.clear();
                  userNameController.clear();
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Save Changes',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                    color: Colors.white,
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
                CircleAvatar(
                  radius: 82,
                  backgroundColor: Color(0xFF181818),
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
                Positioned(
                  bottom: -5,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: Color(0xFF282828),
                      child: SvgPicture.asset(
                        'assets/images/camera-01.svg',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              username ?? "",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(height: 6),
            Text(
              'One task at a time. One step closer.',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Color(0xFFC6C6C6),
                fontWeight: FontWeight.normal,
              ),
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
                ),
                SizedBox(width: 16),
                Text(
                  'User Details',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontSize: 20),
                ),
                Spacer(),
                SvgPicture.asset(
                  'assets/images/Trailing element.svg',
                  width: 30,
                  height: 30,
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
                ),
                SizedBox(width: 16),
                Text(
                  'Dark Mode',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontSize: 20),
                ),
                Spacer(),
                Switch(value: true, onChanged: (_) {}),
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
                ),
                SizedBox(width: 16),
                Text(
                  'Log Out',
                  style: Theme.of(
                    context,
                  ).textTheme.displaySmall?.copyWith(fontSize: 20),
                ),
                Spacer(),
                SvgPicture.asset(
                  'assets/images/Trailing element.svg',
                  width: 30,
                  height: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

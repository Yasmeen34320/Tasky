import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                  'Completed Tasks',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

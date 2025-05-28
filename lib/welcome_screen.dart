import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/tasks_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
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
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 28,
                    letterSpacing: 0.5,
                  ),
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
            SvgPicture.asset('assets/images/pana.svg', width: 215, height: 204),
            SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Full Name',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'e.g. Sarah Khalid',
                hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                fillColor: Color(0xFF282828),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return TasksScreen();
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Let'
                  's Get Started',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

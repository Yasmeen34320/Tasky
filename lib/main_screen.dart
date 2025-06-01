import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/completed_tasks_screen.dart';
import 'package:tasky/controllers/profile_controller.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/profile_screen.dart';
import 'package:tasky/tasks_screen.dart';
import 'package:tasky/to_do_screen.dart';
import 'package:tasky/welcome_screen.dart';
import 'package:tasky/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> screens = <Widget>[
    TasksScreen(),
    ToDoScreen(),
    CompletedTasksScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskController>(
          create: (context) => TaskController()..init(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (context) => ProfileController()..init(),
        ),
      ],
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/home.svg',
                color: (_selectedIndex == 0)
                    ? Color(0xFF15B86C)
                    : Color(0xFFC6C6C6),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/todo.svg',
                color: (_selectedIndex == 1)
                    ? Color(0xFF15B86C)
                    : Color(0xFFC6C6C6),
              ),
              label: 'To Do',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/complete.svg',
                color: (_selectedIndex == 2)
                    ? Color(0xFF15B86C)
                    : Color(0xFFC6C6C6),
              ),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/profile.svg',
                color: (_selectedIndex == 3)
                    ? Color(0xFF15B86C)
                    : Color(0xFFC6C6C6),
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,

          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

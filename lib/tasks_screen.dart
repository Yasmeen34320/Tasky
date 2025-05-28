import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/add_new_task_screen.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddNewTaskScreen();
                },
              ),
            ),
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(200, 40)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Add New Task',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 52),
            Row(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFF181818),
                  backgroundImage: AssetImage('assets/images/image.png'),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Evening ,Usama ',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 2,
                      ),
                    ),

                    SizedBox(height: 8),
                    Text(
                      'One task at a time.One step \ncloser.',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Yuhuu ,Your work Is ',
              style: TextTheme.of(
                context,
              ).displayMedium?.copyWith(fontSize: 32),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Text(
                  ' almost done !',
                  style: TextTheme.of(
                    context,
                  ).displayMedium?.copyWith(fontSize: 32),
                ),
                SizedBox(width: 4),
                SvgPicture.asset('assets/images/hand.svg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

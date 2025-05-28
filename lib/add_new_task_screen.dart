import 'package:flutter/material.dart';

class AddNewTaskScreen extends StatelessWidget {
  const AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 52),

            Text(
              'New Task',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 50),
            Text(
              'Task Name',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontSize: 17),
            ),
            SizedBox(height: 8),
            TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Finish UI design for login screen',
                hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                fillColor: Color(0xFF282828),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            SizedBox(height: 361),
            ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Add Task',
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

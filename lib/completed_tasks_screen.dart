import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  List<dynamic> value = [], completedTasks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); // ✅ Add this

    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? task = prefs.getString('tasks');

    if (task != null) {
      value = jsonDecode(task);
      completedTasks = value.where((task) => task['isDone'] == 1).toList();
      print("Loaded tasks: $completedTasks");
    }
    setState(() {}); // <- trigger rebuild
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
                  'Completed Tasks',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: completedTasks.length,
                padding: EdgeInsets.symmetric(vertical: 8),

                itemBuilder: (context, index) {
                  final task = completedTasks[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF282828),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // child: Text(task['title'],),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: task['isDone'] == 1 ? true : false,
                              onChanged: (value1) async {
                                setState(() {
                                  print(value1);
                                  task['isDone'] = value1! ? 1 : 0;
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString(
                                  'tasks',
                                  jsonEncode(value),
                                ); // save whole task list
                                getData(); // reload and rebuild
                              }, // Optional: handle check action
                              activeColor: Color.fromRGBO(21, 184, 108, 1),
                            ),
                            Text(
                              task['title'],
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: task['isDone'] == 1
                                        ? Color(0xFFA0A0A0)
                                        : Colors.white,
                                    decoration: task['isDone'] == 1
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    fontSize: 19,
                                    decorationColor: Color(0xFFA0A0A0),
                                    // 👈 change line-through color here
                                  ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/images/dots.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

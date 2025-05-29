import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/add_new_task_screen.dart';

class TasksScreen extends StatefulWidget {
  TasksScreen({super.key});
  // String username;
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // SharedPreferences prefs=await SharedPreferences.getInstance();
  String? username;
  List<dynamic> value = [], highpriority = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState(); // ✅ Add this

    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    String? task = prefs.getString('tasks');
    if (task != null) {
      value = jsonDecode(task);
      highpriority = value
          .where((task) => task['isHighPriority'] == 1)
          .toList();
      print("Loaded tasks: $highpriority");
    }
    setState(() {}); // <- trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    print("All tasks: $value");

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () async => {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddNewTaskScreen();
                },
              ),
            ),
            getData(),
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(250, 40)),
          label: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Add New Task',
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          icon: Icon(Icons.add),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 52),
              Row(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Color(0xFF181818),
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Evening ,$username ',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w200,
                              letterSpacing: 2,
                            ),
                      ),

                      SizedBox(height: 8),
                      Text(
                        'One task at a time.One step \ncloser.',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
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
              SizedBox(height: 24),
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Color(0xFF282828),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Achieved Tasks',
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(fontSize: 20),
                          ),
                          SizedBox(height: 3),
                          Text(
                            '3 Out of 6 Done ',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: Color(0xFFC6C6C6),
                                  fontSize: 17,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              Container(
                height: 230,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFF282828),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'High Priority Tasks',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(color: Color(0xFF15B86C), fontSize: 17),
                      ),
                      SizedBox(
                        height: 170,
                        child: ListView.builder(
                          itemCount: highpriority.length,
                          padding: EdgeInsets.all(8),

                          itemBuilder: (context, index) {
                            final task = highpriority[index];

                            return Row(
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
                                  activeColor: Color(0xFF15B86C),
                                ),
                                Text(
                                  task['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: task['isDone'] == 1
                                            ? Color(0xFFA0A0A0)
                                            : Colors.white,
                                        decoration: task['isDone'] == 1
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        fontSize: 17,
                                        decorationColor: Color(0xFFA0A0A0),
                                      ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'My Tasks',
                style: Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(fontSize: 20),
              ),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: value.length,
                  padding: EdgeInsets.symmetric(vertical: 8),

                  itemBuilder: (context, index) {
                    final task = value[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF282828),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 90,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            color: task['isDone'] == 1
                                                ? Color(0xFFA0A0A0)
                                                : Colors.white,
                                            decoration: task['isDone'] == 1
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            fontSize: 17,
                                            decorationColor: Color(0xFFA0A0A0),
                                            // 👈 change line-through color here
                                          ),
                                    ),
                                    if (task['desc'] != null &&
                                        task['desc'].trim().isNotEmpty) ...[
                                      SizedBox(height: 3),
                                      Text(
                                        task['desc'],
                                        style: Theme.of(
                                          context,
                                        ).textTheme.displaySmall,
                                      ),
                                    ],
                                  ],
                                ),
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
      ),
    );
  }
}

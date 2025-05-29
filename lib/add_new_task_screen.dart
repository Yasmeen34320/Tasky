import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/components/custom_text_field.dart';
import 'package:tasky/core/Models/task_model.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isHighPriority = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              CustomTextField(
                controller: taskNameController,
                title: 'Task Name',
                hintText: 'Finish UI design for login screen',
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter the Task name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              CustomTextField(
                controller: taskDescController,
                title: 'Task Description',
                hintText:
                    'Finish onboarding UI and hand off to devs by Thursday.',
                maxLines: 5,
              ),
              SizedBox(height: 20),
              // Text(
              //   'Task Name',
              //   style: Theme.of(
              //     context,
              //   ).textTheme.displaySmall?.copyWith(fontSize: 17),
              // ),
              // SizedBox(height: 8),
              // TextField(
              //   style: TextStyle(color: Colors.white),
              //   cursorColor: Colors.white,
              //   decoration: InputDecoration(
              //     hintText: 'Finish UI design for login screen',
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'High Priority',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Switch(
                    value: isHighPriority,
                    onChanged: (bool value) {
                      setState(() {
                        isHighPriority = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 361),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    String? taskListString = prefs.getString('tasks');
                    List<dynamic> listOfTasks = [];
                    if (taskListString != null) {
                      listOfTasks = jsonDecode(taskListString);

                      /// list of dynamic (from string)
                    }
                    TaskModel task = TaskModel(
                      id: listOfTasks.length + 1,
                      isDone: 0,
                      title: taskNameController.text,
                      desc: taskDescController.text,
                      isHighPriority: isHighPriority,
                    );
                    listOfTasks.add(task.toMap());

                    /// need to convert it to string to use sharedpreference --> jsonEncode
                    String value = jsonEncode(listOfTasks);
                    prefs.setString('tasks', value);
                    taskNameController.clear();
                    taskDescController.clear();
                    print("from add screen " + value);
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.add),
                label: Padding(
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
      ),
    );
  }
}

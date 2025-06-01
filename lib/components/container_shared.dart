import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/components/custom_text_field.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/core/Models/task_model.dart';
import 'package:tasky/enums/task_item_action.dart';
import 'package:tasky/services/preferences_manager.dart';
import 'package:tasky/theme/theme_controller.dart';

class ContainerShared extends StatelessWidget {
  final TaskModel task;
  final bool showDesc;
  final Function(bool?, int?) onChanged;
  final Function(int) onDelete;
  final Function onEdit;
  const ContainerShared({
    super.key,
    required this.task,
    required this.showDesc,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeController.isDark()
              ? Color(0xFF282828)
              : Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        height: 65,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // child: Text(task['title'],),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: task.isDone == 1 ? true : false,
                onChanged: (value1) async {
                  onChanged(value1, task.id);
                }, // Optional: handle check action
                activeColor: Color.fromRGBO(21, 184, 108, 1),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: task.isDone == 1
                            ? ThemeController.isDark()
                                  ? Color(0xFFA0A0A0)
                                  : Color(0xFF6A6A6A)
                            : ThemeController.isDark()
                            ? Color(0xFFFFFCFC)
                            : Color(0xFF161F1B),
                        decoration: task.isDone == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: 16,
                        decorationColor: Color(0xFFA0A0A0),
                        // 👈 change line-through color here
                      ),
                    ),
                    if (task.desc != null && task.desc != "" && showDesc) ...[
                      SizedBox(height: 3),
                      Text(
                        task.desc!,
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(fontSize: 15),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<TaskItemActionsEnum>(
                icon: Icon(Icons.more_vert, color: Color(0xFF6A6A6A)),
                onSelected: (value) async {
                  switch (value) {
                    case TaskItemActionsEnum.markAsDone:
                      onChanged(task.isDone == 1 ? false : true, task.id);
                      break;
                    case TaskItemActionsEnum.delete:
                      await _showAlertDialog(context);

                      break;
                    case TaskItemActionsEnum.edit:
                      final result = await _showButtonSheet(context, task);
                      print(result);
                      if (result == true) {
                        onEdit();
                      }
                      break;
                  }
                },
                itemBuilder: (context) =>
                    TaskItemActionsEnum.values.map((element) {
                      return PopupMenuItem<TaskItemActionsEnum>(
                        value: element,
                        child: Text(element.name),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showAlertDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                onDelete(task.id);
                // controller.deleteTask(task.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

Future<bool?> _showButtonSheet(BuildContext context, TaskModel task) {
  TextEditingController taskNameController = TextEditingController(
    text: task.title,
  );
  TextEditingController taskDescriptionController = TextEditingController(
    text: task.desc,
  );
  final updatedTask;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isHighPriority = task.isHighPriority;

  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (context) {
      return ChangeNotifierProvider<TaskController>(
        create: (context) => TaskController()..init(),
        child: Consumer<TaskController>(
          builder: (BuildContext context, TaskController controller, Widget? child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: key,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    CustomTextField(
                      controller: taskNameController,
                      title: "Task Name",
                      hintText: 'Finish UI design for login screen',
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please Enter Task Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      title: "Task Description",
                      controller: taskDescriptionController,
                      maxLines: 5,
                      hintText:
                          'Finish onboarding UI and hand off to devs by Thursday.',
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'High Priority',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Switch(
                          value: controller
                              .tasks[controller.tasks.indexOf(
                                controller.tasks.firstWhere(
                                  (test) => test.id == task.id,
                                ),
                              )]
                              .isHighPriority,
                          onChanged: (bool value) {
                            int index = controller.tasks.indexOf(
                              controller.tasks.firstWhere(
                                (test) => test.id == task.id,
                              ),
                            );
                            task.isHighPriority = value;
                            controller.toggleHighPriority(value, index);
                            // setState(() {
                            //   isHighPriority = value;
                            // });
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      onPressed: () async {
                        print(
                          'hereeeeee form edit ${key.currentState?.validate()}',
                        );
                        if (key.currentState?.validate() ?? false) {
                          TaskModel newTask = TaskModel(
                            isDone: task.isDone,
                            id: task.id,
                            title: taskNameController.text,
                            isHighPriority: isHighPriority,
                            desc: taskDescriptionController.text,
                          );
                          controller.editTask(newTask);
                          //            final prefTasks = await PreferencesManager()
                          //     .getString(StorageKey.tasks);
                          // tasks<dynamic> tasksTasks = [];
                          // print(' from edittt $prefTasks');
                          // if (prefTasks != null) {
                          //   tasksTasks = jsonDecode(prefTasks);
                          // }
                          // TaskModel newTask = TaskModel(
                          //   isDone: task.isDone,
                          //   id: task.id,
                          //   title: taskNameController.text,
                          //   isHighPriority: isHighPriority,
                          //   desc: taskDescriptionController.text,
                          // );
                          // print('new Task $newTask');
                          // final item = tasksTasks.firstWhere(
                          //   (test) => test['id'] == task.id,
                          // );
                          // print('item $item');
                          // final int index = tasksTasks.indexOf(item);
                          // tasksTasks[index] = newTask.toMap();
                          // print('$index');
                          // final taskForPref = jsonEncode(tasksTasks);
                          // await PreferencesManager().setString(
                          //   StorageKey.tasks,
                          //   taskForPref,
                          // );
                          // print('taskks after update $taskForPref');

                          Navigator.of(context).pop(true);
                        }
                      },
                      label: Text('Edit Task'),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

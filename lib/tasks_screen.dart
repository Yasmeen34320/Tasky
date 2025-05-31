import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/add_new_task_screen.dart';
import 'package:tasky/components/container_shared.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/core/Models/task_model.dart';
import 'package:tasky/highpriority_screen.dart';
import 'package:tasky/services/preferences_manager.dart';

// class TasksScreen extends StatefulWidget {
//   TasksScreen({super.key});
//   // String username;
//   @override
//   // Removed: State<TasksScreen> createState() => _TasksScreenState();
//   // No need for createState in StatelessWidget
//   State<TasksScreen> createState() => _TasksScreenState();
// }

class TasksScreen extends StatelessWidget {
  // SharedPreferences prefs=await SharedPreferences.getInstance();
  TasksScreen({super.key});

  String? username;
  int doneTasks = 0;
  List<dynamic> value = [], highpriority = [];
  List<TaskModel> list = [];
  bool isLoading = true;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState(); // ✅ Add this

  //   getData();
  // }

  // void getData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   username = prefs.getString('username');
  //   String? task = prefs.getString('tasks');
  //   if (task != null) {
  //     value = jsonDecode(task);
  //     list = value.map((task) => TaskModel.fromMap(task)).toList();
  //     highpriority = value
  //         .where((task) => task['isHighPriority'] == 1)
  //         .toList();
  //     doneTasks = value.where((task) => task['isDone'] == 1).length;
  //     print("Loaded tasks: $highpriority");
  //   }
  //   setState(() {
  //     isLoading = false;
  //   }); // <- trigger rebuild
  // }

  // void deleteTask(int? id) async {
  //   List<TaskModel> tasks = [];
  //   // print('hereeeeeeeeeeeee');
  //   // print('id $id');
  //   if (id == null) return;
  //   final prefTasks = await PreferencesManager().getString(StorageKey.tasks);
  //   // print("pref $prefTasks");

  //   if (prefTasks != null) {
  //     final List<dynamic> decoded = jsonDecode(prefTasks);

  //     tasks = decoded.map((task) => TaskModel.fromMap(task)).toList();
  //     tasks.removeWhere((test) => test.id == id);

  //     setState(() {
  //       list.removeWhere((test) => test.id == id);
  //       highpriority.removeWhere((test) => test['id'] == id);
  //     });
  //     final updatedTask = tasks.map((toElement) => toElement.toMap()).toList();
  //     PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("All tasks: $value");

    return Scaffold(
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                final bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return AddNewTaskScreen();
                    },
                  ),
                );
                if (result != null && result) {
                  context.read<TaskController>().getData();
                }
                // getData(),
              },
              style: ElevatedButton.styleFrom(fixedSize: Size(250, 40)),
              label: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Add New Task',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              icon: Icon(Icons.add),
            ),
          );
        },
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
                  Selector<TaskController, String?>(
                    selector: (context, TaskController controller) =>
                        controller.userImagePath,
                    builder:
                        (
                          BuildContext context,
                          String? userImagePath,
                          Widget? child,
                        ) {
                          return CircleAvatar(
                            radius: 32,
                            backgroundColor: Color(0xFF181818),
                            backgroundImage: userImagePath == null
                                ? AssetImage('assets/images/avatar.png')
                                : FileImage(File(userImagePath)),
                          );
                        },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<TaskController, String?>(
                          selector: (context, TaskController controller) =>
                              controller.username,
                          builder:
                              (
                                BuildContext context,
                                String? username,
                                Widget? child,
                              ) {
                                return Text(
                                  'Good Evening ,${username} ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w200,
                                        letterSpacing: 2,
                                      ),
                                );
                              },
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
                  ),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: Color(0xFF282828),
                    child: SvgPicture.asset(
                      'assets/images/sun.svg',
                      width: 23,
                      height: 23,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
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
              Consumer<TaskController>(
                builder: (BuildContext context, TaskController controller, Widget? child) {
                  return controller.isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator(), // Or a custom small loader
                        )
                      : Container(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(fontSize: 20),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      '${controller.doneTasks} Out of ${controller.tasks.length} Done ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            color: Color(0xFFC6C6C6),
                                            fontSize: 17,
                                          ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Background (gray circle)
                                      Transform.scale(
                                        scale: 1.7,
                                        child: CircularProgressIndicator(
                                          value: 1.0,
                                          valueColor: AlwaysStoppedAnimation(
                                            Color(0xFFA0A0A0),
                                          ),
                                          strokeWidth: 4,
                                        ),
                                      ),
                                      // Foreground (green progress)
                                      Transform.scale(
                                        scale: 1.7,
                                        child: CircularProgressIndicator(
                                          value: controller.percent,
                                          valueColor: AlwaysStoppedAnimation(
                                            Color(0xFF15B86C),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          strokeWidth: 4,
                                        ),
                                      ),
                                      // Centered text
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          // (doneTasks / list.length)
                                          '${(controller.percent * 100).toInt()}%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
              SizedBox(height: 16),

              Stack(
                children: [
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
                                ?.copyWith(
                                  color: Color(0xFF15B86C),
                                  fontSize: 17,
                                ),
                          ),

                          /// sized box with hight 170
                          Consumer<TaskController>(
                            builder:
                                (
                                  BuildContext context,
                                  TaskController controller,
                                  Widget? child,
                                ) {
                                  return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        controller.highpriority.length > 3
                                        ? 3
                                        : controller.highpriority.length,
                                    padding: EdgeInsets.all(8),

                                    itemBuilder: (context, index) {
                                      final task =
                                          controller.highpriority[index];

                                      return Row(
                                        children: [
                                          Checkbox(
                                            value: task['isDone'] == 1
                                                ? true
                                                : false,
                                            onChanged: (value1) async {
                                              int index = controller.tasks
                                                  .indexOf(
                                                    controller.tasks.firstWhere(
                                                      (test) =>
                                                          test.id == task['id'],
                                                    ),
                                                  );
                                              controller.doneTask(
                                                value1,
                                                index,
                                              );
                                              // setState(() {
                                              //   print(value1);
                                              //   task['isDone'] = value1!
                                              //       ? 1
                                              //       : 0;
                                              // });
                                              // SharedPreferences prefs =
                                              //     await SharedPreferences.getInstance();
                                              // await prefs.setString(
                                              //   'tasks',
                                              //   jsonEncode(value),
                                              // ); // save whole task list
                                              // getData(); // reload and rebuild
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
                                                  decoration:
                                                      task['isDone'] == 1
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : TextDecoration.none,
                                                  fontSize: 17,
                                                  decorationColor: Color(
                                                    0xFFA0A0A0,
                                                  ),
                                                ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 25,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HighPriorityTasks();
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(
                          5,
                        ), // space between border and avatar
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF6E6E6E), // border color
                            width: 1, // border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 25,

                          backgroundColor: Color(0xFF282828),
                          child: SvgPicture.asset(
                            'assets/images/arrow-1.svg',
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                child: Consumer<TaskController>(
                  builder:
                      (
                        BuildContext context,
                        TaskController controller,
                        Widget? child,
                      ) {
                        return ListView.builder(
                          itemCount: controller.tasks.length,
                          padding: EdgeInsets.symmetric(vertical: 8),

                          itemBuilder: (context, index) {
                            final task = controller.tasks[index];

                            return ContainerShared(
                              task: task,
                              showDesc: true,
                              onDelete: (_) async {
                                controller.deleteTask(task.id);
                                // deleteTask(task.id);
                              },
                              onChanged: (value, id) async {
                                print("id is ${controller.tasks[index].id}");
                                int index1 = controller.tasks.indexOf(
                                  controller.tasks.firstWhere(
                                    (test) =>
                                        test.id == controller.tasks[index].id,
                                  ),
                                );
                                controller.doneTask(value, index1);

                                // int? index1;
                                // if (list
                                //     .firstWhere((test) => test.id == id)
                                //     .isHighPriority) {
                                //   index1 = highpriority.indexOf(
                                //     highpriority.firstWhere(
                                //       (test) => test['id'] == id,
                                //     ),
                                //   );
                                // }
                                // print('before change ${list[index!].isDone}');
                                // setState(() {
                                //   list[index!].isDone = value! ? 1 : 0;
                                //   if (index1 != null &&
                                //       index1 < highpriority.length) {
                                //     highpriority[index1!]['isDone'] = value!
                                //         ? 1
                                //         : 0;
                                //   }
                                // });
                                // final allData = PreferencesManager()
                                //     .getString(StorageKey.tasks);
                                // print('after change ${list[index].isDone}');
                                // print('all Data $allData');
                                // if (allData != null) {
                                //   List<TaskModel> allDataList =
                                //       (jsonDecode(allData) as List)
                                //           .map(
                                //             (element) =>
                                //                 TaskModel.fromMap(element),
                                //           )
                                //           .toList();
                                //   final int newIndex = allDataList.indexWhere(
                                //     (e) => e.id == list[index!].id,
                                //   );
                                //   allDataList[newIndex] = list[index];

                                //   await PreferencesManager().setString(
                                //     StorageKey.tasks,
                                //     jsonEncode(
                                //       allDataList
                                //           .map((e) => e.toMap())
                                //           .toList(),
                                //     ),
                                //   );
                                //   getData();
                                // }
                              },
                              onEdit: () {
                                controller.getData();
                                // getData();
                              },
                            );
                          },
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

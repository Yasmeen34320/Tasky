import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/add_new_task_screen.dart';
import 'package:tasky/components/container_shared.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/controllers/profile_controller.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/core/Models/task_model.dart';
import 'package:tasky/highpriority_screen.dart';
import 'package:tasky/services/preferences_manager.dart';
import 'package:tasky/theme/theme_controller.dart';

class TasksScreen extends StatelessWidget {
  // SharedPreferences prefs=await SharedPreferences.getInstance();
  TasksScreen({super.key});

  String? username;
  int doneTasks = 0;
  List<dynamic> value = [], highpriority = [];
  List<TaskModel> list = [];
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    print("All tasks: $value");
    // final profilecontroller = context.read<ProfileController>()..init();

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
                    color: Color(0xFFFFFFFF),
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
                  Selector<ProfileController, String?>(
                    selector: (context, ProfileController controller) =>
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
                        Selector<ProfileController, String?>(
                          selector: (context, ProfileController controller) =>
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
                                        letterSpacing: 2,
                                        color: ThemeController.isDark()
                                            ? Colors.white
                                            : Color(0xFF161F1B),
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
                    backgroundColor: ThemeController.isDark()
                        ? Color(0xFF282828)
                        : Color(0xFFFFFFFF),
                    child: ThemeController.isDark()
                        ? SvgPicture.asset(
                            'assets/images/sun.svg',
                            width: 23,
                            height: 23,
                          )
                        : SvgPicture.asset(
                            'assets/images/moon-01.svg',
                            width: 23,
                            height: 23,
                            color: Colors.black,
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
                            color: ThemeController.isDark()
                                ? Color(0xFF282828)
                                : Color(0xFFFFFFFF),
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
                                            color: ThemeController.isDark()
                                                ? Color(0xFFC6C6C6)
                                                : Color(0xFF3A4640),
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
                      color: ThemeController.isDark()
                          ? Color(0xFF282828)
                          : Color(0xFFFFFFFF),
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
                                            value: task.isDone == 1
                                                ? true
                                                : false,
                                            onChanged: (value1) async {
                                              int index = controller.tasks
                                                  .indexOf(
                                                    controller.tasks.firstWhere(
                                                      (test) =>
                                                          test.id == task.id,
                                                    ),
                                                  );
                                              controller.doneTask(
                                                value1,
                                                index,
                                              );
                                            }, // Optional: handle check action
                                            activeColor: Color(0xFF15B86C),
                                          ),
                                          Text(
                                            task.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall
                                                ?.copyWith(
                                                  color: task.isDone == 1
                                                      ? ThemeController.isDark()
                                                            ? Color(0xFFA0A0A0)
                                                            : Color(0xFF6A6A6A)
                                                      : ThemeController.isDark()
                                                      ? Color(0xFFFFFCFC)
                                                      : Color(0xFF161F1B),
                                                  decoration: task.isDone == 1
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
                      onTap: () async {
                        final bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HighPriorityTasks();
                            },
                          ),
                        );
                        if (result != null && result) {
                          context.read<TaskController>().getData();
                        }
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

                          backgroundColor: ThemeController.isDark()
                              ? Color(0xFF282828)
                              : Color(0xFFFFFFFF),
                          child: SvgPicture.asset(
                            'assets/images/arrow-1.svg',
                            width: 18,
                            height: 18,
                            color: ThemeController.isDark()
                                ? Colors.white
                                : Color(0xFF161F1B),
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

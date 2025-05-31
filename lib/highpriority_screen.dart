import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/components/container_shared.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/core/Models/task_model.dart';
import 'package:tasky/services/preferences_manager.dart';

class HighPriorityTasks extends StatefulWidget {
  const HighPriorityTasks({super.key});

  @override
  State<HighPriorityTasks> createState() => _HighPriorityTasksState();
}

class _HighPriorityTasksState extends State<HighPriorityTasks> {
  List<dynamic> value = [];
  List<TaskModel> highPriority = [];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState(); // ✅ Add this

  //   getData();
  // }

  // void getData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? task = prefs.getString('tasks');

  //   if (task != null) {
  //     value = jsonDecode(task);
  //     highPriority = value
  //         .map((task) => TaskModel.fromMap(task))
  //         .where((task) => task.isHighPriority)
  //         .toList();
  //     print("Loaded tasks: $highPriority");
  //   }
  //   setState(() {}); // <- trigger rebuild
  // }

  // void deleteTask(int? id) async {
  //   List<TaskModel> tasks = [];
  //   if (id == null) return;
  //   final prefTasks = PreferencesManager().getString(StorageKey.tasks);
  //   if (prefTasks != null) {
  //     tasks = jsonDecode(
  //       prefTasks,
  //     ).map((task) => TaskModel.fromMap(task)).toList();
  //     tasks.removeWhere((test) => test.id == id);

  //     setState(() {
  //       highPriority.removeWhere((test) => test.id == id);
  //     });
  //     final updatedTask = tasks.map((toElement) => toElement.toMap()).toList();
  //     PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 52),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/images/arrow.svg',
                    width: 30,
                    height: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 4),
              Text(
                'HighPriority Tasks',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
          SizedBox(height: 16),
          Consumer<TaskController>(
            builder: (BuildContext context, TaskController controller, Widget? child) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.highPriority1.length,
                padding: EdgeInsets.only(bottom: 60),
                itemBuilder: (BuildContext context, int index) {
                  return ContainerShared(
                    task: controller.highPriority1[index],
                    showDesc: false,
                    onDelete: (int? id) {
                      controller.deleteTask(controller.highPriority1[index].id);
                    },
                    onChanged: (value, id) async {
                      int index1 = controller.tasks.indexOf(
                        controller.tasks.firstWhere(
                          (test) =>
                              test.id == controller.highPriority1[index].id,
                        ),
                      );
                      controller.doneTask(value, index1);

                      //   int index = highPriority.indexOf(
                      //     highPriority.firstWhere((test) => test.id == id),
                      //   );

                      //   print(
                      //     'before change ${highPriority[index!].isDone}',
                      //   );
                      //   setState(() {
                      //     highPriority[index!].isDone = value! ? 1 : 0;
                      //   });
                      //   final allData = PreferencesManager().getString(
                      //     StorageKey.tasks,
                      //   );
                      //   print('after change ${highPriority[index].isDone}');
                      //   print('all Data $allData');
                      //   if (allData != null) {
                      //     List<TaskModel> allDataList =
                      //         (jsonDecode(allData) as List)
                      //             .map(
                      //               (element) => TaskModel.fromMap(element),
                      //             )
                      //             .toList();
                      //     final int newIndex = allDataList.indexWhere(
                      //       (e) => e.id == highPriority[index!].id,
                      //     );
                      //     allDataList[newIndex] = highPriority[index];

                      //     await PreferencesManager().setString(
                      //       StorageKey.tasks,
                      //       jsonEncode(
                      //         allDataList.map((e) => e.toMap()).toList(),
                      //       ),
                      //     );
                      //     getData();
                      //   }
                    },
                    onEdit: () {
                      controller.getData();
                    },
                    // onChanged: (bool? value) {
                    //   onTap(value, index);
                    // },
                    // onDelete: (int id) {
                    //   onDelete(id);
                    // },
                    // onEdit: () => onEdit(),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 8);
                },
              );
            },
          ),

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: completedTasks.length,
          //     padding: EdgeInsets.symmetric(vertical: 8),

          //     itemBuilder: (context, index) {
          //       final task = completedTasks[index];
          //       return ContainerShared(task: task, showDesc: false);
          //       // return Padding(
          //       //   padding: const EdgeInsets.all(8.0),
          //       //   child: Container(
          //       //     decoration: BoxDecoration(
          //       //       color: Color(0xFF282828),
          //       //       borderRadius: BorderRadius.circular(20),
          //       //     ),
          //       //     height: 70,
          //       //     child: Padding(
          //       //       padding: const EdgeInsets.all(8.0),
          //       //       // child: Text(task['title'],),
          //       //       child: Row(
          //       //         crossAxisAlignment: CrossAxisAlignment.center,
          //       //         children: [
          //       //           Checkbox(
          //       //             value: task['isDone'] == 1 ? true : false,
          //       //             onChanged: (value1) async {
          //       //               setState(() {
          //       //                 print(value1);
          //       //                 task['isDone'] = value1! ? 1 : 0;
          //       //               });
          //       //               SharedPreferences prefs =
          //       //                   await SharedPreferences.getInstance();
          //       //               await prefs.setString(
          //       //                 'tasks',
          //       //                 jsonEncode(value),
          //       //               ); // save whole task list
          //       //               getData(); // reload and rebuild
          //       //             }, // Optional: handle check action
          //       //             activeColor: Color.fromRGBO(21, 184, 108, 1),
          //       //           ),
          //       //           Text(
          //       //             task['title'],
          //       //             style: Theme.of(context).textTheme.displaySmall
          //       //                 ?.copyWith(
          //       //                   color: task['isDone'] == 1
          //       //                       ? Color(0xFFA0A0A0)
          //       //                       : Colors.white,
          //       //                   decoration: task['isDone'] == 1
          //       //                       ? TextDecoration.lineThrough
          //       //                       : TextDecoration.none,
          //       //                   fontSize: 19,
          //       //                   decorationColor: Color(0xFFA0A0A0),
          //       //                   // 👈 change line-through color here
          //       //                 ),
          //       //           ),
          //       //           Spacer(),
          //       //           Padding(
          //       //             padding: const EdgeInsets.all(8.0),
          //       //             child: Image.asset('assets/images/dots.png'),
          //       //           ),
          //       //         ],
          //       //       ),
          //       //     ),
          //       //   ),
          //       // );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

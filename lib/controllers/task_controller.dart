import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tasky/constants/storage_key.dart';
import 'package:tasky/core/Models/task_model.dart';

import 'package:tasky/services/preferences_manager.dart';

class TaskController with ChangeNotifier {
  List<TaskModel> tasksList = [];

  List<TaskModel> tasks = [];
  bool isLoading = false;
  int totalTask = 0;
  // int totalDoneTasks = 0;
  double percent = 0;
  bool addHighPriority = true;
  int doneTasks = 0;
  List<dynamic> value = [], highpriority = [];
  // List<TaskModel> list = [];

  List<TaskModel> todoTasks = [];
  // List<TaskModel> highPriority1 = [];
  List<TaskModel> completedTasks = [];

  init() {
    // loadUserData();
    getData();
  }

  void getData() async {
    // username = PreferencesManager().getString(StorageKey.username);
    String? task = PreferencesManager().getString(StorageKey.tasks);
    if (task != null) {
      value = jsonDecode(task);
      tasks = value.map((task) => TaskModel.fromMap(task)).toList();
      // tasks = list;
      // highPriority1 = tasks.where((test) => test.isHighPriority).toList();
      // completedTasks = tasks.where((test) => test.isDone == 1).toList();
      // todoTasks = tasks.where((test) => test.isDone == 0).toList();
      // highpriority = value
      //     .where((task) => task['isHighPriority'] == 1)
      //     .toList();
      loadTasks();
      doneTasks = tasks.where((task) => task.isDone == 1).length;
      print("Loaded tasks: $highpriority");
    }
    // <- trigger rebuild
    isLoading = false;
    calculatePercent();
    notifyListeners();
  }

  calculatePercent() {
    totalTask = tasks.length;
    doneTasks = completedTasks.length;
    // totalDoneTasks = tasks.where((e) => e.isDone == 1).length;
    percent = totalTask == 0 ? 0 : doneTasks / totalTask;
  }

  doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value! ? 1 : 0;
    loadTasks();
    // if (highpriority.contains(
    //   highpriority.firstWhere((test) => test['id'] == tasks[index].id),
    // )) {
    //   highpriority[highpriority.indexOf(
    //     highpriority.firstWhere((test) => test['id'] == tasks[index].id),
    //   )!]['isDone'] = value!
    //       ? 1
    //       : 0;
    // }
    // if (highPriority1.contains(
    //   highPriority1.firstWhere((test) => test.id == tasks[index].id),
    // )) {
    //   highPriority1[highPriority1.indexOf(
    //         highPriority1.firstWhere((test) => test.id == tasks[index].id),
    //       )!]
    //       .isDone = value!
    //       ? 1
    //       : 0;
    // }
    // if (completedTasks.contains(
    //   completedTasks.firstWhere((test) => test.id == tasks[index].id),
    // )) {
    //   completedTasks[completedTasks.indexOf(
    //         completedTasks.firstWhere((test) => test.id == tasks[index].id),
    //       )!]
    //       .isDone = value!
    //       ? 1
    //       : 0;
    // }
    // if (todoTasks.contains(
    //   todoTasks.firstWhere((test) => test.id == tasks[index].id),
    // )) {
    //   todoTasks[todoTasks.indexOf(
    //         todoTasks.firstWhere((test) => test.id == tasks[index].id),
    //       )!]
    //       .isDone = value!
    //       ? 1
    //       : 0;
    // }
    // highPriority1 = tasks.where((test) => test.isHighPriority).toList();
    // completedTasks = tasks.where((test) => test.isDone == 1).toList();
    // todoTasks = tasks.where((test) => test.isDone == 0).toList();
    // // highpriority = tasks.where((task) => task.isHighPriority).toList();
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTask),
    );
    // task['isDone'] = value1! ? 1 : 0;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('tasks', jsonEncode(value)); // save whole task list
    // getData();

    notifyListeners();
  }

  deleteTask(int? id) async {
    // if (id == null) return;
    // tasks.removeWhere((task) => task.id == id);
    // calculatePercent();
    // final updatedTask = tasks.map((element) => element.toMap()).toList();
    // PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    // List<TaskModel> tasks = [];
    // print('hereeeeeeeeeeeee');
    print('id $id');
    if (id == null) return;
    // final prefTasks = await PreferencesManager().getString(StorageKey.tasks);
    //  print("pref $tasks");

    // if (prefTasks != null) {
    //   final List<dynamic> decoded = jsonDecode(prefTasks);

    // tasks = decoded.map((task) => TaskModel.fromMap(task)).toList();
    tasks.removeWhere((test) => test.id == id);
    // highpriority.removeWhere((test) => test['id'] == id);
    // highPriority1.removeWhere((test) => test.isHighPriority);
    // completedTasks.removeWhere((test) => test.isDone == 1);
    // todoTasks.removeWhere((test) => test.isDone == 0);
    print('tasks from delete $tasks');
    loadTasks();

    calculatePercent();
    final updatedTask = tasks.map((toElement) => toElement.toMap()).toList();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTask),
    );
    //  getData();

    print(updatedTask);
    notifyListeners();
  }

  loadTasks() async {
    completedTasks = tasks.where((test) => test.isDone == 1).toList();
    todoTasks = tasks.where((test) => test.isDone == 0).toList();
    highpriority = tasks.where((task) => task.isHighPriority).toList();
  }

  toggleAddHighPriority(bool value) {
    addHighPriority = value;
    notifyListeners();
  }

  toggleHighPriority(bool value, int index) async {
    tasks[index].isHighPriority = value;
    calculatePercent();
    print(value);
    final updatedTask = tasks.map((element) => element.toMap()).toList();

    print(updatedTask);
    // highpriority = tasks.where((task) => task.isHighPriority).toList();
    // // highPriority1 = tasks.where((test) => test.isHighPriority).toList();
    // completedTasks = tasks.where((test) => test.isDone == 1).toList();
    // todoTasks = tasks.where((test) => test.isDone == 0).toList();
    loadTasks();
    await PreferencesManager().setString(
      StorageKey.tasks,
      jsonEncode(updatedTask),
    );

    notifyListeners();
  }

  editTask(TaskModel task) async {
    //tasks final prefTasks = await PreferencesManager().getString(StorageKey.tasks);
    // List<dynamic> listTasks = [];
    print(' from edittt $tasks');
    // if (tasks != null) {
    //   listTasks = jsonDecode(tasks);
    // }
    //list tasks
    // TaskModel newTask = TaskModel(
    //   isDone: task.isDone,
    //   id: task.id,
    //   title: taskNameController.text,
    //   isHighPriority: isHighPriority,
    //   desc: taskDescriptionController.text,
    // );
    TaskModel newTask = TaskModel(
      isDone: task.isDone,
      id: task.id,
      title: task.title,
      isHighPriority: task.isHighPriority,
      desc: task.desc,
    );
    print('new Task $newTask');
    final item = tasks.firstWhere((test) => test.id == task.id);
    print('item $item');
    final int index = tasks.indexOf(item);
    // tasks[index] = newTask.toMap();
    tasks[index] = newTask;
    print('$index');
    final taskForPref = jsonEncode(tasks.map((t) => t.toMap()).toList());
    print('taskks after update $taskForPref');
    // highPriority1 = tasks.where((test) => test.isHighPriority).toList();
    // completedTasks = tasks.where((test) => test.isDone == 1).toList();
    // todoTasks = tasks.where((test) => test.isDone == 0).toList();

    loadTasks();
    await PreferencesManager().setString(StorageKey.tasks, taskForPref);

    notifyListeners();
  }

  addTask(TaskModel newTask) async {
    //  SharedPreferences prefs =
    //                               await SharedPreferences.getInstance();
    print("addTask called with: ${newTask.toMap()}"); // ✅ LOG

    // String? taskListString = PreferencesManager().getString(StorageKey.tasks);
    // List<dynamic> listOfTasks = [];
    // if (taskListString != null) {
    //   listOfTasks = jsonDecode(taskListString);

    //   /// list of dynamic (from string)
    // }
    // TaskModel task = TaskModel(
    //   id: listOfTasks.length + 1,
    //   isDone: 0,
    //   title: taskNameController.text,
    //   desc: taskDescController.text,
    //   isHighPriority: isHighPriority,
    // );
    tasks.add(newTask); //
    List<Map<String, dynamic>> taskListJson = tasks
        .map((task) => task.toMap())
        .toList();

    /// need to convert it to string to use sharedpreference --> jsonEncode
    String value = jsonEncode(taskListJson);
    // highPriority1 = tasks.where((test) => test.isHighPriority).toList();
    // completedTasks = tasks.where((test) => test.isDone == 1).toList();
    // todoTasks = tasks.where((test) => test.isDone == 0).toList();
    loadTasks();
    await PreferencesManager().setString(StorageKey.tasks, value);

    notifyListeners();
  }
}

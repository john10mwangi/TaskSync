import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/app/models/task_model.dart';

// This class will be used to perform CRUD operations to
// Tasks items, stored in .json file
class ApiService with ListenableServiceMixin {
  // Public contructor for the service.
  ApiService() {
    listenToReactiveValues([_mockedData]);
  }
  // Path to the json file
  static const String _assetPath = 'assets/tasks.json';

  List<TaskModel> _mockedData = [];
  Map<int, TaskModel> _tasksMap = {};

  // List<TaskModel> tasks getter
  List<TaskModel> get tasks => _mockedData;

  // Map<int, TaskModel> tasks getter
  Map<int, TaskModel> get taskMap => _tasksMap;

  /// Get path for local JSON file
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/tasks.json');
  }

  /// Load JSON file from assets and copy it to local storage
  Future<void> _copyJsonToLocalStorage() async {
    final file = await _getLocalFile();
    if (!file.existsSync()) {
      String jsonString = await rootBundle.loadString(_assetPath);
      await file.writeAsString(jsonString);
    }
  }

  /// Fetching data from json file and
  /// Converting dynamic type data to List<TaskModel>
  getTasksWithPostProcessing() async {
    var response = await _initFetchTasks();
    _mockedData = response
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
    _tasksMap = Map<int, TaskModel>.fromIterable(
      _mockedData,
      key: (task) => task.id, // Use TaskModel.id as the key
      value: (task) => task, // Use the TaskModel itself as the value
    );
    notifyListeners();
  }

  /// Fetch tasks from the local JSON file
  Future<List<dynamic>> _initFetchTasks() async {
    await _copyJsonToLocalStorage(); // Ensure local copy exists
    final file = await _getLocalFile();
    return jsonDecode(await file.readAsString());
  }

/// This method updates the specific field os a task and updates the json file
  Future<void> updateTask(int id, Map<String, dynamic> updatedData) async {
    final file = await _getLocalFile();
    List<dynamic> tasks = await _initFetchTasks();

    int index = tasks.indexWhere((task) => task["id"] == id);
    if (index != -1) {
      tasks[index] = {...tasks[index], ...updatedData}; // Merge old + new data
      await file.writeAsString(jsonEncode(tasks));
      _mockedData.firstWhere((task) {
        if (task.id == id) {
          task.completed = !task.completed;
        }
        return task.id == id;
      });
      notifyListeners();
    } else {
      debugPrint("Task not found!");
    }
  }

/// Method to create task and storing it to the 
/// json file.
  Future<void> addTask(TaskModel task) async {
    final file = await _getLocalFile();

    // Read existing tasks
    List<dynamic> tasks = await _initFetchTasks();

    // Convert to List<TaskModel>
    List<TaskModel> taskList = tasks.map((e) => TaskModel.fromJson(e)).toList();

    // Add new task
    taskList.add(task);

    // Convert TaskModel list to JSON list
    List<Map<String, dynamic>> jsonList =
        taskList.map((task) => task.toJson()).toList();

    // Write updated tasks back to file
    await file.writeAsString(jsonEncode(jsonList));

    //update the variables holding the tasks
    _mockedData.add(task);
    _tasksMap[task.id] = task;
    notifyListeners();
  }

/// This method deletes a task from the json file.
  Future<bool> deleteTask(int id) async {
    try {
      final file = await _getLocalFile();

      // Read existing tasks
      List<dynamic> tasks = await _initFetchTasks();

      // Convert JSON to List<TaskModel>
      List<TaskModel> taskList =
          tasks.map((e) => TaskModel.fromJson(e)).toList();

      // Remove task with matching ID
      taskList.removeWhere((task) => task.id == id);

      // Convert back to JSON format
      List<Map<String, dynamic>> jsonList =
          taskList.map((task) => task.toJson()).toList();

      // Write updated list back to file
      await file.writeAsString(jsonEncode(jsonList));


    //update the variables holding the tasks
      _mockedData.removeWhere((task) => task.id == id);
      _tasksMap.remove(id);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:task_sync/app/models/task_model.dart';

import '../../../app/app.locator.dart';
import '../../../services/api_service.dart';

/// This ViewModel class provides data to AddTask View UI.
class AddTaskSheetModel extends ReactiveViewModel {
  final _apiService = locator<ApiService>();

  //  Task Priorities options for dropdown.
  var priorities = ["High", "Medium", "Low"];
  // Task priority field default/ Selected option.
  String selectedPriority = "Medium";
  // Task title field
  String createTaskTitle = "";
  // Task due date field.
  DateTime? dueDate;
  // Task due date field TextEditingController.
  TextEditingController dueDateController = TextEditingController();
  // NotificationManager Channel
  static const _channel = MethodChannel('reminder_channel');
  // Datetime format "yyyy-MM-dd"
  DateFormat format = DateFormat("yyyy-MM-dd");
  // bottomsheet service.
  final _bottomSheetService = locator<BottomSheetService>();

  // Tasks  getter
  List<TaskModel> get tasks => _apiService.tasks;
  Map<int, TaskModel> get taskMapping => _apiService.taskMap;

///  This method is used to setup Android Notification/Reminder. 
///  This is the entry point for the native android call invokation.
  Future<void> setReminder(int timeInMillis, String message) async {
    if (Platform.isAndroid) {
      final result = await _channel.invokeMethod('setReminder', {
        'timeInMillis': timeInMillis,
        'message': message,
      });
    }
  }

///  This method helps in finding the highest id from the tasks
  int getHighestId() {
    if (taskMapping.isEmpty) {
      throw Exception("The map is empty");
    }
    int maxId = taskMapping.keys.first; // Initialize with the first key
    for (var id in taskMapping.keys) {
      if (id > maxId) {
        maxId = id;
      }
    }
    return maxId;
  }

// Setter for task field selectedPriority
  void setSelectedPriority(String onChanged) {
    selectedPriority = onChanged;
    notifyListeners();
  }

// Setter for task field title
  void setTaskTitle(String value) {
    createTaskTitle = value;
  }

// Setter method for task field duedate
  void setDueDate(DateTime pickedDate) {
    dueDate = pickedDate;
    dueDateController.text = format.format(pickedDate);
    notifyListeners();
  }

  ///  Method to create task.
  ///
  void createTask() async {
    print("createTask : $dueDate");
    await _apiService.addTask(TaskModel(
        id: getHighestId() + 1,
        completed: false,
        title: createTaskTitle,
        priority: selectedPriority,
        dueDate: dueDate == null ? null : format.format(dueDate!)));

    int reminderTime = dueDate == null
        ? DateTime.now().millisecondsSinceEpoch + 60000
        : calcTimeToDate(dueDate!); // 1 min later
    setReminder(reminderTime, createTaskTitle);
    notifyListeners();

    _bottomSheetService.completeSheet(
        SheetResponse(confirmed: true, data: {"refresh": "yes"}));
  }

  /* Calculate the times in microseconds bewteen two dates
  */
  int calcTimeToDate(DateTime due) {
    var now = DateTime.now();
    var dif = due.difference(now).inMilliseconds;
    return dif;
  }

///   Registering _apiService as a listenable service within the Stacked architecture.
  @override
  List<ListenableServiceMixin> get listenableServices => [_apiService];
}

import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../app/models/task_model.dart';
import '../../../services/api_service.dart';
import '../../common/app_strings.dart';

/// This class provides data to the TaskView UI.
class TasksViewModel extends ReactiveViewModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _apiService = locator<ApiService>();

/// Timer for purpose of polling
  late Timer _timer;

///  Filter selection options
  var filters = ["All", "High", "Medium", "Low", "Completed", "Pending"];

/// Filter selection "All" is the default
  var filter = "All";

  ///  This methods set the filter from selection and
  ///  fetch respective data depending on the sselection
  setFilter(String choice) {
    filter = choice;
    fetchFilteredTasks();
    notifyListeners();
  }

  List<TaskModel> _filteredTasks = [], _unfiltered = [];

/// Task List<TaskModel> variable getter.
  List<TaskModel> get tasks => _filteredTasks;

  /// This method refreshes the data by fetching it from the file.
  void startPolling() {
    fetchAllTasks();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _apiService.getTasksWithPostProcessing(); // Fetch every 10 seconds
      fetchAllTasks(); // update the tasks
    });
  }

  // method to populate the tasks list
  void fetchAllTasks() async {
    _unfiltered = _apiService.tasks;
    fetchFilteredTasks();
    notifyListeners();
  }

  /// Filters task depending on the filter selected from the UI
  ///  and updates the task lisk
  Future<void> fetchFilteredTasks() async {
    switch (filter) {
      case "Medium":
        _filteredTasks =
            _unfiltered.where((task) => task.priority == "Medium").toList();
        break;
      case "High":
        _filteredTasks =
            _unfiltered.where((task) => task.priority == "High").toList();
        break;
      case "Low":
        _filteredTasks =
            _unfiltered.where((task) => task.priority == "Low").toList();
        break;
      case "Completed":
        _filteredTasks =
            _unfiltered.where((task) => task.completed == true).toList();
        break;
      case "Pending":
        _filteredTasks =
            _unfiltered.where((task) => task.completed == false).toList();
        break;
      default:
        _filteredTasks = _unfiltered;
        break;
    }
    notifyListeners();
  }

//  Update completed field in task
  void toggleCompleted(int id) {
    var task = tasks.firstWhere((_task) => _task.id == id);
    _apiService.updateTask(id, {"completed": !task.completed});
    fetchAllTasks();
    notifyListeners();
  }

// Method to delete task.
  void deleteTask(int id) async {
    await _apiService.deleteTask(id);
    fetchAllTasks();
    notifyListeners();
  }

  /// Navigates to AddTask bottomsheet
  void showBottomSheet() async {
    var data = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
    // Refresh the data
    if (data?.data != null) {
      fetchAllTasks();
    }
  }

/// This override disposes the timer when ViewModel is destroyed.
  @override
  set disposed(bool _disposed) {
    _timer.cancel(); // Stop polling when ViewModel is disposed
    super.disposed = _disposed;
  }

///   Registering _apiService as a listenable service within the Stacked architecture.
  @override
  List<ListenableServiceMixin> get listenableServices => [_apiService];
}

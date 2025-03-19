import 'package:task_sync/app/app.bottomsheets.dart';
import 'package:task_sync/app/app.dialogs.dart';
import 'package:task_sync/app/app.locator.dart';
import 'package:task_sync/app/app.router.dart';
import 'package:task_sync/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/models/task_model.dart';
import '../../../services/api_service.dart';

// Options
enum Filters { completed, high, low, medium }

/// View Model for DashboardView.
class HomeViewModel extends ReactiveViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();

// helper function to round doubles to 1 decimal place.
  double roundTo1DP(double value) {
    return (value * 10).roundToDouble() / 10;
  }

  List<TaskModel> _tasks = [];
  set tasks(List<TaskModel> newValue) {
    _tasks = newValue;
    calcComplete();
    calcHighPriority();
  }

// Tasks variable getter
  List<TaskModel> get tasks => _tasks;

// Method fecthing data from db.
  Future<void> fetchTasks() async {
    setBusy(true);
    await _apiService.getTasksWithPostProcessing();
    _tasks = _apiService.tasks;
    calcComplete();
    calcHighPriority();
    setBusy(false);
  }

// This method filters tasks depending on completed or priority high
  List<TaskModel>? fetchFiltered(Filters filter) {
    if (filter.name == "completed") {
      return tasks.where((task) => task.completed == true).toList();
    } else if (filter.name == "high") {
      return tasks.where((task) => task.priority == "High").toList();
    }
    return null;
  }

// Calculate the percentage completed for tasks
  double calcComplete() {
    var completedPercentage =
        ((fetchFiltered(Filters.completed)?.length ?? 0) / _tasks.length)
            .toDouble();
    return completedPercentage;
  }

// Calculate share of tasks with priority High
  double calcHighPriority() {
    var priorityHigh =
        ((fetchFiltered(Filters.high)?.length ?? 0) / _tasks.length).toDouble();
    return priorityHigh;
  }

// This method enables navigation to dialog
  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked stars on Github',
    );
  }

// This method enables navigation to add task bottomsheet
  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }

// This method enables navigation from HomeView to TaskView
  void toTasks() {
    _navigationService.navigateToTasksView();
  }

  ///   Registering _apiService as a listenable service within the Stacked architecture.
  @override
  List<ListenableServiceMixin> get listenableServices => [_apiService];
}

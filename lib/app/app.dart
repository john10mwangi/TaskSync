import 'package:task_sync/ui/bottom_sheets/add_task/add_task_sheet.dart';
import 'package:task_sync/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:task_sync/ui/views/home/dashboard_view.dart';
import 'package:task_sync/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:task_sync/services/api_service.dart';
import 'package:task_sync/ui/views/tasks/tasks_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: TasksView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ApiService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: AddTaskSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}

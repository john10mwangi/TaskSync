import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:task_sync/ui/common/app_colors.dart';
import 'package:task_sync/ui/common/ui_helpers.dart';

import 'dashboard_viewmodel.dart';

/// This class provides the UI for the dashboard.
class DashboardView extends StackedView<HomeViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // Container to show analytics
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text("Total Tasks : ${viewModel.tasks.length}",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: Platform.isAndroid
                                ? const EdgeInsets.all(20)
                                : const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Container(
                              // Container showing Priority analytics
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: SizedBox(
                                        child: viewModel.tasks.isEmpty
                                            ? const CircularProgressIndicator
                                                .adaptive()
                                            : CircularProgressIndicator
                                                .adaptive(
                                                value: viewModel.roundTo1DP(1 -
                                                    viewModel
                                                        .calcHighPriority()),
                                                strokeWidth: 16,
                                                // strokeAlign: 2,
                                                backgroundColor:
                                                    Platform.isAndroid
                                                        ? Colors.yellow[900]
                                                        : Colors.yellow,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      child: viewModel.tasks.isEmpty
                                          ? const CircularProgressIndicator
                                              .adaptive()
                                          : Text(
                                              "${viewModel.roundTo1DP(viewModel.calcHighPriority() * 100)}%",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                    ),
                                    const Text("High Priority",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: Platform.isAndroid
                                ? const EdgeInsets.all(20)
                                : const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Container(
                              // Container showing Completed analytics
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: SizedBox(
                                        child: viewModel.tasks.isEmpty
                                            ? const CircularProgressIndicator
                                                .adaptive()
                                            : CircularProgressIndicator
                                                .adaptive(
                                                value: viewModel.roundTo1DP(1 -
                                                    viewModel.calcComplete()),
                                                strokeWidth: 16,
                                                // strokeAlign: 9,
                                                backgroundColor:
                                                    Platform.isAndroid
                                                        ? Colors.yellow[900]
                                                        : Colors.yellow,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      child: viewModel.tasks.isEmpty
                                          ? const CircularProgressIndicator
                                              .adaptive()
                                          : Text(
                                              "${viewModel.roundTo1DP(viewModel.calcComplete() * 100)}%",
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                    ),
                                    const Text("Completed",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: MaterialButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: viewModel.toTasks,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text(
                        'View All Tasks',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: viewModel.showBottomSheet,
      //   tooltip: 'Add Task',
      //   label: Text("Add Task"),
      //   icon: const Icon(Icons.add),
      // ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) {
    super.onViewModelReady(viewModel);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchTasks();
    });
  }
}

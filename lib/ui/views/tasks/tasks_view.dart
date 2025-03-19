import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'tasks_viewmodel.dart';

/**
 * This class provide the UI for the user to view their tasks and update them.
 */
class TasksView extends StackedView<TasksViewModel> {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TasksViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the Screen Title and use it to set our appbar title.
        title: const Text("Task List"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: DropdownButton<String>(
                value: viewModel.filter,
                icon: const Icon(
                  Icons.filter_list_rounded,
                  size: 20,
                ),
                items: viewModel.filters.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (onChanged) {
                  if (onChanged != null) {
                    viewModel.setFilter(onChanged);
                  }
                },
              ),
            ),
            Expanded(
              // child: ListView.builder(
              //   itemCount: viewModel.tasks.length,
              //   itemBuilder: (context, index) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 10.0),
              //       child: ListBody(
              //         children: [
              //           Row(
              //             mainAxisSize: MainAxisSize.max,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Expanded(
              //                 child: Column(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   mainAxisSize: MainAxisSize.max,
              //                   crossAxisAlignment: CrossAxisAlignment.stretch,
              //                   children: [
              //                     Text(viewModel.tasks[index].title,
              //                         maxLines: 2,
              //                         overflow: TextOverflow.ellipsis,
              //                         style: const TextStyle(
              //                             fontSize: 16,
              //                             fontWeight: FontWeight.w600)),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: Text(
              //                           viewModel.tasks[index].dueDate ?? "N/A",
              //                           style: const TextStyle(
              //                               fontSize: 16,
              //                               fontWeight: FontWeight.w200)),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: Container(
              //                         padding: const EdgeInsets.symmetric(
              //                             vertical: 4),
              //                         child:
              //                             Text(viewModel.tasks[index].priority,
              //                                 style: TextStyle(
              //                                   fontSize: 14,
              //                                   fontWeight: FontWeight.w400,
              //                                   color: Colors.yellow[900],
              //                                 )),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //               SizedBox(width: 16),
              //               IntrinsicWidth(
              //                 child: Column(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceEvenly,
              //                   mainAxisSize: MainAxisSize.min,
              //                   crossAxisAlignment: CrossAxisAlignment.end,
              //                   children: [
              //                     PopupMenuButton(
              //                       itemBuilder: (context) {
              //                         return [
              //                           PopupMenuItem(
              //                             onTap: () {
              //                               viewModel.toggleCompleted(
              //                                   viewModel.tasks[index].id);
              //                             },
              //                             child: Text(
              //                                 viewModel.tasks[index].completed
              //                                     ? "Pending"
              //                                     : "Completed"),
              //                           ),
              //                           PopupMenuItem(
              //                               onTap: () {
              //                                 viewModel.deleteTask(
              //                                     viewModel.tasks[index].id);
              //                               },
              //                               child: const Text("Delete")),
              //                         ];
              //                       },
              //                     ),
              //                     Container(
              //                       padding: const EdgeInsets.symmetric(
              //                           vertical: 4, horizontal: 12),
              //                       decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           border: Border.all(
              //                               color: Colors.yellow[900]!),
              //                           borderRadius:
              //                               BorderRadius.circular(20.0)),
              //                       child: Text(viewModel.tasks[index].completed
              //                           ? "Completed"
              //                           : "Pending"),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           )
              //         ],
              //       ),
              //     );
              //   },
              // ),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListBody(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(viewModel.tasks[index].title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          viewModel.tasks[index].dueDate ??
                                              "N/A",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w200)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Text(
                                            viewModel.tasks[index].priority,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.yellow[900],
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              IntrinsicWidth(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    PopupMenuButton(
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            onTap: () {
                                              viewModel.toggleCompleted(
                                                  viewModel.tasks[index].id);
                                            },
                                            child: Text(
                                                viewModel.tasks[index].completed
                                                    ? "Pending"
                                                    : "Completed"),
                                          ),
                                          PopupMenuItem(
                                              onTap: () {
                                                viewModel.deleteTask(
                                                    viewModel.tasks[index].id);
                                              },
                                              child: const Text("Delete")),
                                        ];
                                      },
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.yellow[900]!),
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Text(
                                          viewModel.tasks[index].completed
                                              ? "Completed"
                                              : "Pending"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: const Divider(
                        height: 2,
                      ),
                    );
                  },
                  itemCount: viewModel.tasks.length),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.showBottomSheet();
        },
        backgroundColor: Colors.yellow[900],
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  TasksViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TasksViewModel();

  @override
  void onViewModelReady(TasksViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.startPolling();
  }
}

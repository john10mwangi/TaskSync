import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'add_task_sheet_model.dart';

/// Add Task Bottom Sheet UI.
/// This class displays UI to create Task.
class AddTaskSheet extends StackedView<AddTaskSheetModel> {
  final Function(SheetResponse)? completer;
  final SheetRequest request;
  const AddTaskSheet({
    Key? key,
    required this.completer,
    required this.request,
  }) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddTaskSheetModel viewModel,
    Widget? child,
  ) {
    var bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, bottom + 24),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Text(
                        "Create Task",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    onChanged: (value) {
                      viewModel.setTaskTitle(value);
                    },
                    decoration: const InputDecoration(label: Text("Title *")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: Text("Priority *")),
                      DropdownButton<String>(
                        value: viewModel.selectedPriority,
                        items: viewModel.priorities.map((priority) {
                          return DropdownMenuItem<String>(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        onChanged: (onChanged) {
                          if (onChanged != null) {
                            viewModel.setSelectedPriority(onChanged);
                          }
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: viewModel.dueDateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 360)),
                      );
                      if (pickedDate != null) {
                        viewModel.setDueDate(pickedDate);
                      }
                    },
                    decoration: const InputDecoration(
                        label: Text("Due Date (Optional)")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        minimumSize:
                            WidgetStatePropertyAll(Size.fromHeight(56))),
                    onPressed: viewModel.createTaskTitle.isNotEmpty
                        ? () {
                            viewModel.createTask();
                          }
                        : null,
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  AddTaskSheetModel viewModelBuilder(BuildContext context) =>
      AddTaskSheetModel();
}

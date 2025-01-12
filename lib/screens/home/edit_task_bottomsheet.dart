import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/resources/app_colors.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/resources/widgets.dart';

class EditTaskBottomSheet extends StatefulWidget {
  final TaskProvider taskProvider;
  final Task task;

  const EditTaskBottomSheet({super.key, required this.taskProvider, required this.task});

  @override
  State<EditTaskBottomSheet> createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  late TextEditingController _taskController;

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task.title);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: getWidgetWidth(width: 20),
            vertical: getWidgetHeight(height: 20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Edit Task',
                  labelStyle: TextStyle(
                    color: appColors.authBtnColor,
                    fontWeight: FontWeight.w600,
                    fontSize: getTextSize(fontSize: 22),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: appColors.authBtnColor),
                  ),
                ),
                cursorColor: appColors.authBtnColor,
              ),
              SizedBox(height: getWidgetHeight(height: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      final newTitle = _taskController.text.trim();
                      if (newTitle.isNotEmpty) {
                        widget.taskProvider.editTask(widget.task.id, newTitle);
                      }
                      Navigator.pop(context);
                    },
                    child: Widgets().commonBtn(
                      name: 'Edit Task',
                      height: 30,
                      width: 100,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: getWidgetWidth(width: 10)),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Widgets().commonBtn(
                      name: 'Cancel',
                      height: 30,
                      width: 100,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

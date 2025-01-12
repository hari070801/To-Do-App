import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/resources/app_colors.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/resources/widgets.dart';

class AddTaskBottomSheet extends StatelessWidget {
  AddTaskBottomSheet({super.key});

  final _taskController = TextEditingController();

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
                  labelText: 'Add a new task',
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
                      if (_taskController.text.isNotEmpty) {
                        Provider.of<TaskProvider>(context, listen: false).addTask(_taskController.text);
                        _taskController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Widgets().commonBtn(
                      name: 'Add Task',
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

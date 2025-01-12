import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/provider/auth_provider.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/resources/app_colors.dart';
import 'package:todo_app/resources/functions.dart';
import 'package:todo_app/resources/shared_prefs.dart';
import 'package:todo_app/resources/widgets.dart';
import 'package:todo_app/screens/auth/login_screen.dart';
import 'package:todo_app/screens/home/add_task_bottomsheet.dart';
import 'package:todo_app/screens/home/edit_task_bottomsheet.dart';

String? userEmail;

class HomeScreen extends StatelessWidget {
  List<Task> completedTask = [];
  List<Task> notCompletedTask = [];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'To-Do',
          style: TextStyle(
            color: appColors.fontColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/home/user.png',
            color: Colors.black,
            height: getWidgetHeight(height: 20),
          ),
          onPressed: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: SizedBox(
                    height: getWidgetHeight(height: 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/home/user.png',
                              color: Colors.black,
                              height: getWidgetHeight(height: 14),
                            ),
                            SizedBox(width: getWidgetWidth(width: 5)),
                            Text(
                              userEmail!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: getTextSize(fontSize: 20),
                                color: appColors.fontColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'V 1.0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: getTextSize(fontSize: 14),
                            color: appColors.fontColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/home/logout.png',
              height: getWidgetHeight(height: 20),
            ),
            onPressed: () async {
              try {
                clearLoginState();
                await context.read<AuthProvider>().signOut();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              } finally {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<TaskProvider>(
              builder: (context, taskProvider, _) {
                if (taskProvider.isLoading) {
                  return Center(
                    heightFactor: getWidgetHeight(height: 25),
                    child: Widgets().showLoader(color: appColors.authBtnColor),
                  );
                }

                completedTask = taskProvider.tasks.where((i) => i.isCompleted).toList();
                notCompletedTask = taskProvider.tasks.where((i) => !i.isCompleted).toList();

                print("completedTask : ${completedTask.length}");
                print("notCompletedTask : ${notCompletedTask.length}");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'All Tasks',
                        style: TextStyle(
                          fontSize: getTextSize(fontSize: 20),
                          fontWeight: FontWeight.w700,
                          color: appColors.authBtnColor,
                        ),
                      ),
                    ),
                    notCompletedTask.isEmpty && completedTask.isEmpty
                        ? SizedBox(
                            height: getWidgetHeight(height: 100),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    'No tasks yet',
                                    style: TextStyle(
                                      fontSize: getTextSize(fontSize: 22),
                                      fontWeight: FontWeight.w600,
                                      color: appColors.fontColor,
                                    ),
                                  ),
                                  SizedBox(height: getWidgetHeight(height: 10)),
                                  Text(
                                    'Add your to-dos and keep track of them',
                                    style: TextStyle(
                                      fontSize: getTextSize(fontSize: 18),
                                      fontWeight: FontWeight.w500,
                                      color: appColors.fontColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : notCompletedTask.isEmpty
                            ? SizedBox(
                                height: getWidgetHeight(height: 100),
                                child: Center(
                                  child: Text(
                                    'All tasks completed',
                                    style: TextStyle(
                                      fontSize: getTextSize(fontSize: 20),
                                      fontWeight: FontWeight.w500,
                                      color: appColors.fontColor,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: notCompletedTask.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final task = notCompletedTask[index];

                                  return Padding(
                                    padding: EdgeInsets.only(right: getWidgetWidth(width: 15), left: getWidgetWidth(width: 5)),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.comfortable,
                                      title: Text(
                                        task.title,
                                        style: TextStyle(
                                          decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                        ),
                                      ),
                                      leading: Checkbox(
                                        value: task.isCompleted,
                                        onChanged: (_) => taskProvider.toggleTaskCompletion(task),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/images/home/edit-task.png',
                                              color: Colors.black,
                                              height: getWidgetHeight(height: 18),
                                            ),
                                            onPressed: () {
                                              //showEditTaskDialog(context, taskProvider, task);
                                              showModalBottomSheet(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                                ),
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                isScrollControlled: true,
                                                showDragHandle: false,
                                                isDismissible: true,
                                                enableDrag: true,
                                                backgroundColor: Colors.transparent,
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return EditTaskBottomSheet(
                                                    taskProvider: taskProvider,
                                                    task: task,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Image.asset(
                                              'assets/images/home/delete-task.png',
                                              height: getWidgetHeight(height: 18),
                                            ),
                                            onPressed: () => taskProvider.deleteTask(task.id),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    notCompletedTask.isEmpty && completedTask.isEmpty
                        ? const SizedBox()
                        : completedTask.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Completed Tasks',
                                      style: TextStyle(
                                        fontSize: getTextSize(fontSize: 20),
                                        fontWeight: FontWeight.w700,
                                        color: appColors.greenColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: getWidgetHeight(height: 200),
                                      child: Consumer<TaskProvider>(
                                        builder: (context, taskProvider, _) {
                                          return ListView.builder(
                                            itemCount: completedTask.length,
                                            itemBuilder: (context, index) {
                                              print("completedTask : $completedTask");
                                              final task = completedTask[index];

                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                visualDensity: VisualDensity.comfortable,
                                                title: Text(
                                                  task.title,
                                                  style: TextStyle(
                                                    decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                                  ),
                                                ),
                                                leading: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    taskProvider.toggleTaskCompletion(task);
                                                  },
                                                  icon: const Icon(Icons.check),
                                                  color: appColors.greenColor,
                                                  iconSize: getWidgetHeight(height: 20),
                                                ),
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Image.asset(
                                                        'assets/images/home/edit-task.png',
                                                        color: Colors.black,
                                                        height: getWidgetHeight(height: 18),
                                                      ),
                                                      onPressed: () => showEditTaskDialog(context, taskProvider, task),
                                                    ),
                                                    IconButton(
                                                      icon: Image.asset(
                                                        'assets/images/home/delete-task.png',
                                                        height: getWidgetHeight(height: 18),
                                                      ),
                                                      onPressed: () => taskProvider.deleteTask(task.id),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColors.authBtnColor,
        tooltip: 'Add Task',
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            isScrollControlled: true,
            showDragHandle: false,
            isDismissible: true,
            enableDrag: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return AddTaskBottomSheet();
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

void showEditTaskDialog(BuildContext context, TaskProvider taskProvider, Task task) {
  final TextEditingController controller = TextEditingController(text: task.title);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Task',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: getTextSize(fontSize: 26),
            color: appColors.authBtnColor,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new task title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getTextSize(fontSize: 16),
                color: appColors.authBtnColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                taskProvider.editTask(task.id, newTitle);
              }
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getTextSize(fontSize: 16),
                color: appColors.authBtnColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}

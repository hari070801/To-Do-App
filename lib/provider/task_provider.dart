import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Task> _tasks = [];
  final _db = FirebaseDatabase.instance.ref().child('tasks');

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    isLoading = true;
    notifyListeners();

    try {
      final dataSnapshot = await _db.get();
      if (dataSnapshot.exists) {
        List<Task> loadedTasks = [];
        Map data = dataSnapshot.value as Map;
        data.forEach((id, taskData) {
          loadedTasks.add(Task.fromMap({...taskData, 'id': id}));
        });
        _tasks = loadedTasks;
      }
    } catch (error) {
      print("Error fetching tasks: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in!");
      return;
    }

    final taskId = DateTime.now().toString().replaceAll('.', '-').replaceAll(' ', '_');
    final task = Task(id: taskId, title: title, isCompleted: false);

    isLoading = true;
    notifyListeners();

    try {
      await _db.child(task.id).set(task.toMap());
      _tasks.add(task);
    } catch (error) {
      print("Error updating tasks: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    isLoading = true;
    notifyListeners();

    try {
      await _db.child(task.id).update({'isCompleted': task.isCompleted});
    } catch (error) {
      print("Error updating tasks: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editTask(String taskId, String newTitle) async {
    isLoading = true;
    notifyListeners();

    try {
      // Update the task in Firebase
      await _db.child(taskId).update({'title': newTitle});

      // Update the task locally
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex].title = newTitle;
      }
    } catch (error) {
      print("Error editing tasks: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      await _db.child(id).remove();
      _tasks.removeWhere((task) => task.id == id);
    } catch (error) {
      print("Error deleting tasks: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

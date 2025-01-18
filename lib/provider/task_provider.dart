import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Task> _tasks = [];
  final _db = FirebaseDatabase.instance.ref();

  List<Task> get tasks => _tasks;

  // Fetching task for specific user
  Future<void> fetchTasks() async {
    clearTasks();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("No user is logged in.");
      return;
    }

    final dataSnapshot = await _db.child('users/$userId/tasks').get();
    if (dataSnapshot.exists) {
      List<Task> loadedTasks = [];
      Map data = dataSnapshot.value as Map;
      data.forEach((id, taskData) {
        loadedTasks.add(Task.fromMap({...taskData, 'id': id}));
      });
      _tasks = loadedTasks;
    } else {
      print("No tasks found for the user.");
    }
    notifyListeners();
  }

  // Add new task
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
      await _db.child('users/${user.uid}/tasks/$taskId').set(task.toMap());
      _tasks.add(task); // Add task to the local list
    } catch (error) {
      print("Error adding task: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Toggle the completion status of a task
  Future<void> toggleTaskCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    isLoading = true;
    notifyListeners();

    try {
      await _db.child('users/${FirebaseAuth.instance.currentUser?.uid}/tasks/${task.id}').update({'isCompleted': task.isCompleted});
    } catch (error) {
      print("Error updating task completion: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Edit the task
  Future<void> editTask(String taskId, String newTitle) async {
    isLoading = true;
    notifyListeners();

    try {
      await _db.child('users/${FirebaseAuth.instance.currentUser?.uid}/tasks/$taskId').update({'title': newTitle});

      //locally
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex].title = newTitle;
      }
    } catch (error) {
      print("Error editing task: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    isLoading = true;
    notifyListeners();

    try {
      await _db.child('users/${FirebaseAuth.instance.currentUser?.uid}/tasks/$id').remove();
      _tasks.removeWhere((task) => task.id == id);
    } catch (error) {
      print("Error deleting task: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearTasks() async {
    _tasks = [];
    notifyListeners();
  }
}

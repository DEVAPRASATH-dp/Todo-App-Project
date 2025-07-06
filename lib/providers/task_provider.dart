import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _service = TaskService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  // ✅ Automatically load tasks when provider is created
  TaskProvider() {
    loadTasks();
  }

  void loadTasks() {
    _tasks = _service.getTasks();
    notifyListeners();
  }

  void add(Task task) {
    _service.addTask(task);
    loadTasks(); // ✅ Refresh list after adding
  }

  void update(Task task) {
    _service.updateTask(task);
    loadTasks(); // ✅ Refresh after update
  }

  void delete(String id) {
    _service.deleteTask(id);
    loadTasks(); // ✅ Refresh after delete
  }

  void toggle(Task task) {
    _service.toggleComplete(task);
    loadTasks(); // ✅ Refresh after toggle
  }
}

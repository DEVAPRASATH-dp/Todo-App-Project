import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskService {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  List<Task> getTasks() => _taskBox.values.toList();
  void addTask(Task task) => _taskBox.put(task.id, task);
  void deleteTask(String id) => _taskBox.delete(id);
  void updateTask(Task task) => task.save();
  void toggleComplete(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save();
  }
}

import 'package:flutter/material.dart';
import 'package:notes/app/repository/task_repository.dart';

import '../../model/task.dart';

class TaskProvider extends ChangeNotifier{
  List<Task> _taskList = [];
  final TaskRepository _taskRepository = TaskRepository();

  Future<void> fetchTasks() async {
    try {
      _taskList = await _taskRepository.getTasks();
      notifyListeners();
    } catch (e) {
      print("TaskProvider error: ${e.toString()}");
      _taskList = await _taskRepository.getTasks();
    }
  }

  List<Task> get taskList => _taskList;


  void onTaskDoneChange(Task task) {
    task.done = !task.done;
    _taskRepository.saveTask(_taskList);
    notifyListeners();
  }

  void addTask(Task task) {
    _taskRepository.addTask(task);
    fetchTasks();
  }

  void deleteTask(Task task){
    _taskRepository.deleteTask(task);
    fetchTasks();
  }

  void editTask(Task task){
    _taskRepository.editTask(task);
    fetchTasks();
  }
}
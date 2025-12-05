import 'package:hive/hive.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<void> saveTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

const String taskBoxName = 'tasks_box';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box<TaskModel> taskBox;

  TaskLocalDataSourceImpl(this.taskBox);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    try {
      return taskBox.values.toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    try {
      await taskBox.put(task.id, task);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      await taskBox.put(task.id, task);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    try {
      await taskBox.delete(id);
    } catch (e) {
      throw CacheException();
    }
  }
}

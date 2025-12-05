import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';
import '../utils.dart';


abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final TaskFilter filter;
  const LoadTasks({this.filter = TaskFilter.all});
  @override
  List<Object> get props => [filter];
}

class AddTaskEvent extends TaskEvent {
  final Tasks task;
  const AddTaskEvent(this.task);
  @override
  List<Object> get props => [task];
}

class EditTaskEvent extends TaskEvent {
  final Tasks task;
  const EditTaskEvent(this.task);
  @override
  List<Object> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class ToggleTaskCompletedEvent extends TaskEvent {
  final Tasks task;
  const ToggleTaskCompletedEvent(this.task);
  @override
  List<Object> get props => [task];
}

class UpdateTaskFilter extends TaskEvent {
  final TaskFilter filter;
  const UpdateTaskFilter(this.filter);
  @override
  List<Object> get props => [filter];
}
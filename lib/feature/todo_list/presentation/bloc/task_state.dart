import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';
import '../utils.dart';

class TaskState extends Equatable {
  final List<Tasks> tasks;
  final TaskFilter currentFilter;
  final bool isLoading;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.currentFilter = TaskFilter.all,
    this.isLoading = false,
    this.errorMessage,
  });

  TaskState copyWith({
    List<Tasks>? tasks,
    TaskFilter? currentFilter,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      currentFilter: currentFilter ?? this.currentFilter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [tasks, currentFilter, isLoading, errorMessage];
}

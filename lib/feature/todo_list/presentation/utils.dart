import '../domain/entities/task.dart';

enum TaskFilter { all, active, completed }

enum TaskPriority { high, medium, low }

extension TaskPriorityExtension on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.high:
        return "HIGH";
      case TaskPriority.medium:
        return "MEDIUM";
      case TaskPriority.low:
        return "LOW";
    }
  }
}

extension TaskFilterExtension on Tasks {
  bool matchesFilter(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.all:
        return true;
      case TaskFilter.completed:
        return isCompleted;
      case TaskFilter.active:
        return !isCompleted;
    }
  }
}

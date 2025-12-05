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


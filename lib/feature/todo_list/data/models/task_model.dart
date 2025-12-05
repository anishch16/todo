import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';
import '../../presentation/utils.dart';
part 'task_model.g.dart';

class TaskPriorityAdapter extends TypeAdapter<TaskPriority> {
  @override
  final typeId = 1;

  @override
  TaskPriority read(BinaryReader reader) {
    return TaskPriority.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, TaskPriority obj) {
    writer.writeByte(obj.index);
  }
}

@HiveType(typeId: 0)
class TaskModel extends Tasks {
  @override
  @HiveField(0)
  // ignore: overridden_fields
  final String id;

  @override
  @HiveField(1)
  // ignore: overridden_fields
  final String title;

  @override
  @HiveField(2)
  // ignore: overridden_fields
  final String? description;

  @override
  @HiveField(3)
  // ignore: overridden_fields
  final bool isCompleted;

  @override
  @HiveField(4)
  // ignore: overridden_fields
  final DateTime createdAt;

  @override
  @HiveField(5)
  // ignore: overridden_fields
  final TaskPriority priority;

  @override
  @HiveField(6)
  // ignore: overridden_fields
  final DateTime? dueDate;

  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.priority,
    this.dueDate,
  }) : super(
         id: id,
         title: title,
         description: description,
         isCompleted: isCompleted,
         createdAt: createdAt,
         priority: priority,
         dueDate: dueDate,
       );

  factory TaskModel.fromEntity(Tasks task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      priority: task.priority,
      dueDate: task.dueDate,
    );
  }

  @override
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    TaskPriority? priority,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

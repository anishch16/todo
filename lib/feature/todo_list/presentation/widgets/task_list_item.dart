import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../utils.dart';

class TaskListItem extends StatelessWidget {
  final Tasks task;
  final ValueChanged<Tasks> onToggle;
  final ValueChanged<Tasks> onEdit;
  final ValueChanged<String> onDelete;

  const TaskListItem({
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.amber;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No Due Date';
    return 'Due: ${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(100),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      task.title,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty)
                      Text(
                        task.description!,
                        maxLines: 15,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontSize: 16),
                      ),

                    Text(
                      _formatDate(task.dueDate),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                height: 16,
                width: 16,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  menuPadding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_horiz_outlined),
                  onSelected: (String result) {
                    if (result == 'edit') {
                      onEdit(task);
                    } else if (result == 'delete') {
                      onDelete(task.id);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ' ${task.priority.name.toUpperCase()} Priority',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
              Transform.scale(
                scale: 1.2,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      if (value != null) {
                        onToggle(task);
                      }
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

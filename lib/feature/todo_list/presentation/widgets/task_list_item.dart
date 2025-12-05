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
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 8.0, left: 16),
        leading: InkWell(
          child: Icon(
            task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            color: task.isCompleted ? Colors.green : theme.colorScheme.primary,
          ),
          onTap: () => onToggle(task),
        ),
        title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              ' ${task.priority.name.toUpperCase()} Priority',
              style: TextStyle(
                color: _getPriorityColor(task.priority),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _formatDate(task.dueDate),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          menuPadding: EdgeInsets.zero,
          icon: const Icon(Icons.menu),
          onSelected: (String result) {
            if (result == 'edit') {
              onEdit(task);
            } else if (result == 'delete') {
              onDelete(task.id);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        onTap: () => onEdit(task),
      ),
    );
  }
}

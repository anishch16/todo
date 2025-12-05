import 'package:flutter/material.dart';
import '../utils.dart';

class TaskFilterButton extends StatelessWidget {
  final TaskFilter filter;
  final TaskFilter currentFilter;
  final ValueChanged<TaskFilter> onSelected;

  const TaskFilterButton({
    required this.filter,
    required this.currentFilter,
    required this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = (filter == currentFilter);
    return ChoiceChip(
      label: Text(filter.name.toUpperCase()),
      selected: isSelected,
      elevation: 2,
      onSelected: (_) => onSelected(filter),
      selectedColor: theme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

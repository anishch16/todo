import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../utils.dart';
import '../widgets/common_datefield_picker.dart';
import '../widgets/common_text_field.dart';

class TaskDetailPage extends StatefulWidget {
  final Tasks? task;

  const TaskDetailPage({this.task, super.key});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final Uuid _uuid = const Uuid();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _selectedPriority = task?.priority ?? TaskPriority.medium;
    _selectedDueDate = task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final isEditing = widget.task != null;
      final newTask = Tasks(
        id: isEditing ? widget.task!.id : _uuid.v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        isCompleted: widget.task?.isCompleted ?? false,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        priority: _selectedPriority,
        dueDate: _selectedDueDate,
      );
      if (isEditing) {
        context.read<TaskBloc>().add(EditTaskEvent(newTask));
      } else {
        context.read<TaskBloc>().add(AddTaskEvent(newTask));
      }
      Navigator.of(context).pop();
    }
  }

  InputBorder _getBorder({
    Color? color,
    BorderType borderType = BorderType.outline,
  }) {
    switch (borderType) {
      case BorderType.outline:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color ?? Colors.grey),
        );
      case BorderType.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color ?? Colors.grey),
        );
      case BorderType.none:
        return InputBorder.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add New Task'),
        centerTitle: false,

        leadingWidth: 25,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(
                controller: _titleController,
                labelText: 'Title',
                hintText: "eg: Buy groceries",
                maxLength: 50,
                showCounter: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              CommonTextField(
                controller: _descriptionController,
                maxLines: 4,
                minLines: 3,
                labelText: 'Description (Optional)',
                hintText: "eg: Buy groceries for the week",
                maxLength: 255,
                showCounter: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField2<TaskPriority>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  hintText: "eg: High, Medium, Low",
                  enabledBorder: _getBorder(),
                  focusedBorder: _getBorder(
                    color: Theme.of(context).primaryColor,
                  ),
                  errorBorder: _getBorder(color: Colors.red),
                  focusedErrorBorder: _getBorder(color: Colors.red),
                ),

                dropdownStyleData: const DropdownStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  direction: DropdownDirection.right,
                  maxHeight: 250,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.zero,
                ),
                selectedItemBuilder: (context) {
                  return TaskPriority.values.map((priority) {
                    return Text("${priority.name.toUpperCase()} PRIORITY");
                  }).toList();
                },
                items: TaskPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text("${priority.name.toUpperCase()} PRIORITY"),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedPriority = newValue;
                    });
                  }
                },
              ),
              DatePickerField(
                selectedDate: _selectedDueDate,
                labelText: 'Due Date',
                hintText: 'Select Due Date (Optional)',
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _selectedDueDate = picked);
                  }
                },
                onClear: _selectedDueDate != null
                    ? () => setState(() => _selectedDueDate = null)
                    : null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveTask,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isEditing ? 'Update Task' : 'Add Task',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

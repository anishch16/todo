import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../utils.dart';
import '../widgets/task_filter_button.dart';
import '../widgets/task_list_item.dart';
import 'task_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;
    final taskBloc = context.read<TaskBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight - 16),
          child: BlocBuilder<TaskBloc, TaskState>(
            buildWhen: (previous, current) =>
                previous.currentFilter != current.currentFilter,
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: TaskFilter.values.map((filter) {
                    return TaskFilterButton(
                      filter: filter,
                      currentFilter: state.currentFilter,
                      onSelected: (selectedFilter) {
                        context.read<TaskBloc>().add(
                          UpdateTaskFilter(selectedFilter),
                        );
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.tasks.isEmpty) {
            return Center(
              child: Text(
                'No tasks found for "${state.currentFilter.name}" filter.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWideScreen ? 700 : double.infinity,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return TaskListItem(
                    task: task,
                    onToggle: (Tasks t) {
                      taskBloc.add(ToggleTaskCompletedEvent(t));
                    },
                    onEdit: (Tasks t) {
                      _navigateToDetail(context, t);
                    },
                    onDelete: (String id) {
                      taskBloc.add(DeleteTaskEvent(id));
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToDetail(context, null),
        tooltip: 'Add New Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Tasks? task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TaskBloc>(),
          child: TaskDetailPage(task: task),
        ),
      ),
    );
  }
}

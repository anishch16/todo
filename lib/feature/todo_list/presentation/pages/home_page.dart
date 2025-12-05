import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import '../../domain/entities/task.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../utils.dart';
import '../widgets/task_list_item.dart';
import 'task_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskBloc = context.read<TaskBloc>();

    return DefaultTabController(
      length: TaskFilter.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Todo App',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            isScrollable: false,
            tabAlignment: TabAlignment.fill,
            indicatorColor: theme.colorScheme.secondary,
            labelColor: theme.colorScheme.secondary,
            padding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: TaskFilter.values.map((filter) {
              return Tab(text: filter.name.toUpperCase());
            }).toList(),
            onTap: (index) {
              final selectedFilter = TaskFilter.values[index];
              taskBloc.add(UpdateTaskFilter(selectedFilter));
            },
          ),
        ),
        body: TabBarView(
          children: TaskFilter.values.map((filter) {
            return BlocConsumer<TaskBloc, TaskState>(
              listenWhen: (previous, current) =>
                  previous.errorMessage != current.errorMessage,
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                }
              },
              buildWhen: (previous, current) =>
                  previous.tasks != current.tasks ||
                  previous.isLoading != current.isLoading ||
                  previous.currentFilter != current.currentFilter,
              builder: (context, state) {
                final tasks = state.tasks
                    .where((t) => t.matchesFilter(filter))
                    .toList();

                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      'No tasks found for "${filter.name}" filter.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                return SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;

                      if (isWide) {
                        return WaterfallFlow.builder(
                          padding: const EdgeInsets.all(
                            16,
                          ).copyWith(bottom: 100),
                          gridDelegate:
                              const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return TaskListItem(
                              task: task,
                              onToggle: (Tasks t) => context
                                  .read<TaskBloc>()
                                  .add(ToggleTaskCompletedEvent(t)),
                              onEdit: (Tasks t) =>
                                  _navigateToDetail(context, t),
                              onDelete: (String id) => context
                                  .read<TaskBloc>()
                                  .add(DeleteTaskEvent(id)),
                            );
                          },
                        );
                      } else {
                        return ListView.separated(
                          padding: const EdgeInsets.all(
                            16,
                          ).copyWith(bottom: 100),
                          itemCount: tasks.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return TaskListItem(
                              task: task,
                              onToggle: (Tasks t) => context
                                  .read<TaskBloc>()
                                  .add(ToggleTaskCompletedEvent(t)),
                              onEdit: (Tasks t) =>
                                  _navigateToDetail(context, t),
                              onDelete: (String id) => context
                                  .read<TaskBloc>()
                                  .add(DeleteTaskEvent(id)),
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              },
            );
          }).toList(),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () => _navigateToDetail(context, null),
          tooltip: 'Add New Task',
          child: const Icon(Icons.add),
        ),
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

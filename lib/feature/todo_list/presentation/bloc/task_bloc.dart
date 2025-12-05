import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_task_uc.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/edit_task_uc.dart';
import '../../domain/usecases/get_filtered_task.dart';
import '../../domain/usecases/update_task_status.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetFilteredTasks getFilteredTasks;
  final AddTask addTask;
  final EditTask editTask;
  final DeleteTask deleteTask;
  final UpdateTaskStatus updateTaskStatus;

  TaskBloc({
    required this.getFilteredTasks,
    required this.addTask,
    required this.editTask,
    required this.deleteTask,
    required this.updateTaskStatus,
  }) : super(const TaskState()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<EditTaskEvent>(_onEditTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletedEvent>(_onToggleCompleted);
    on<UpdateTaskFilter>(_onUpdateFilter);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getFilteredTasks(FilterParams(filter: event.filter));
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: 'Failed to load tasks.'),
      ),
      (tasks) => emit(
        state.copyWith(
          tasks: tasks,
          currentFilter: event.filter,
          isLoading: false,
        ),
      ),
    );
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    final result = await addTask(event.task);
    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: 'Failed to add task.'));
      },
      (_) {
        add(LoadTasks(filter: state.currentFilter));
      },
    );
  }

  Future<void> _onEditTask(EditTaskEvent event, Emitter<TaskState> emit) async {
    final result = await editTask(event.task);
    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: 'Failed to edit task.'));
      },
      (_) {
        add(LoadTasks(filter: state.currentFilter));
      },
    );
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final result = await deleteTask(event.taskId);
    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: 'Failed to delete task.'));
      },
      (_) {
        add(LoadTasks(filter: state.currentFilter));
      },
    );
  }

  Future<void> _onToggleCompleted(
    ToggleTaskCompletedEvent event,
    Emitter<TaskState> emit,
  ) async {
    final updatedTask = event.task.copyWith(
      isCompleted: !event.task.isCompleted,
    );

    final result = await updateTaskStatus(updatedTask);
    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: 'Failed to update task status.'));
      },
      (_) {
        add(LoadTasks(filter: state.currentFilter));
      },
    );
  }

  void _onUpdateFilter(UpdateTaskFilter event, Emitter<TaskState> emit) {
    add(LoadTasks(filter: event.filter));
  }
}

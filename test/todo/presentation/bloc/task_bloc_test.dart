import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo/core/errors/failure.dart';
import 'package:todo/feature/todo_list/domain/entities/task.dart';
import 'package:todo/feature/todo_list/domain/usecases/add_task_uc.dart';
import 'package:todo/feature/todo_list/domain/usecases/delete_task.dart';
import 'package:todo/feature/todo_list/domain/usecases/edit_task_uc.dart';
import 'package:todo/feature/todo_list/domain/usecases/get_filtered_task.dart';
import 'package:todo/feature/todo_list/domain/usecases/update_task_status.dart';
import 'package:todo/feature/todo_list/presentation/bloc/task_bloc.dart';
import 'package:todo/feature/todo_list/presentation/bloc/task_event.dart';
import 'package:todo/feature/todo_list/presentation/bloc/task_state.dart';
import 'package:todo/feature/todo_list/presentation/utils.dart';

import 'task_bloc_test.mocks.dart';

@GenerateMocks([
  GetFilteredTasks,
  AddTask,
  EditTask,
  DeleteTask,
  UpdateTaskStatus,
])
void main() {
  late MockGetFilteredTasks mockGetFilteredTasks;
  late MockAddTask mockAddTask;
  late MockEditTask mockEditTask;
  late MockDeleteTask mockDeleteTask;
  late MockUpdateTaskStatus mockUpdateTaskStatus;

  late TaskBloc bloc;

  final testTask = Tasks(
    id: '1',
    title: 'Test',
    description: 'Test Desc',
    isCompleted: false,
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockGetFilteredTasks = MockGetFilteredTasks();
    mockAddTask = MockAddTask();
    mockEditTask = MockEditTask();
    mockDeleteTask = MockDeleteTask();
    mockUpdateTaskStatus = MockUpdateTaskStatus();

    bloc = TaskBloc(
      getFilteredTasks: mockGetFilteredTasks,
      addTask: mockAddTask,
      editTask: mockEditTask,
      deleteTask: mockDeleteTask,
      updateTaskStatus: mockUpdateTaskStatus,
    );
  });

  group('LoadTasks', () {
    final tasks = [testTask];

    blocTest<TaskBloc, TaskState>(
      'emits loading then loaded tasks on success',
      build: () {
        when(mockGetFilteredTasks(any)).thenAnswer((_) async => Right(tasks));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTasks(filter: TaskFilter.all)),
      expect: () => [
        const TaskState(isLoading: true),
        TaskState(
          tasks: tasks,
          isLoading: false,
          currentFilter: TaskFilter.all,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits error message on failure',
      build: () {
        when(
          mockGetFilteredTasks(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTasks(filter: TaskFilter.all)),
      expect: () => [
        const TaskState(isLoading: true),
        const TaskState(
          isLoading: false,
          errorMessage: 'Failed to load tasks.',
        ),
      ],
    );
  });

  group('AddTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'calls LoadTasks after successful add',
      build: () {
        when(mockAddTask(any)).thenAnswer((_) async => const Right(null));
        when(
          mockGetFilteredTasks(any),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(AddTaskEvent(testTask)),
      verify: (_) {
        verify(mockAddTask(testTask)).called(1);
        verify(mockGetFilteredTasks(any)).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits error on add failure',
      build: () {
        when(mockAddTask(any)).thenAnswer(
          (_) async => Left(InputFailure(message: "Failed to add task.")),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(AddTaskEvent(testTask)),
      expect: () => [const TaskState(errorMessage: 'Failed to add task.')],
    );
  });

  group('EditTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'reloads tasks after successful edit',
      build: () {
        when(mockEditTask(any)).thenAnswer((_) async => const Right(null));
        when(
          mockGetFilteredTasks(any),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(EditTaskEvent(testTask)),
      verify: (_) {
        verify(mockEditTask(testTask)).called(1);
        verify(mockGetFilteredTasks(any)).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits error on edit failure',
      build: () {
        when(mockEditTask(any)).thenAnswer(
          (_) async => Left(InputFailure(message: "Failed to edit task.")),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(EditTaskEvent(testTask)),
      expect: () => [const TaskState(errorMessage: 'Failed to edit task.')],
    );
  });

  group('DeleteTaskEvent', () {
    blocTest<TaskBloc, TaskState>(
      'reloads tasks after successful delete',
      build: () {
        when(mockDeleteTask(any)).thenAnswer((_) async => const Right(null));
        when(
          mockGetFilteredTasks(any),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteTaskEvent('1')),
      verify: (_) {
        verify(mockDeleteTask('1')).called(1);
        verify(mockGetFilteredTasks(any)).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits error on delete failure',
      build: () {
        when(mockDeleteTask(any)).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteTaskEvent('1')),
      expect: () => [const TaskState(errorMessage: 'Failed to delete task.')],
    );
  });

  group('ToggleTaskCompletedEvent', () {
    final toggledTask = testTask.copyWith(isCompleted: true);

    blocTest<TaskBloc, TaskState>(
      'reloads tasks after success',
      build: () {
        when(
          mockUpdateTaskStatus(any),
        ).thenAnswer((_) async => const Right(null));
        when(
          mockGetFilteredTasks(any),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(ToggleTaskCompletedEvent(testTask)),
      verify: (_) {
        verify(mockUpdateTaskStatus(toggledTask)).called(1);
        verify(mockGetFilteredTasks(any)).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits error on status update failure',
      build: () {
        when(
          mockUpdateTaskStatus(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(ToggleTaskCompletedEvent(testTask)),
      expect: () => [
        const TaskState(errorMessage: 'Failed to update task status.'),
      ],
    );
  });

  group('UpdateTaskFilter', () {
    blocTest<TaskBloc, TaskState>(
      'dispatches LoadTasks',
      build: () {
        when(
          mockGetFilteredTasks(any),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateTaskFilter(TaskFilter.completed)),
      verify: (_) {
        verify(mockGetFilteredTasks(any)).called(1);
      },
    );
  });
}

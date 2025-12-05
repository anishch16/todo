import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'feature/todo_list/data/datasources/local_datasource.dart';
import 'feature/todo_list/data/models/task_model.dart';
import 'feature/todo_list/data/repositories/task_repository_impl.dart';
import 'feature/todo_list/domain/repositories/task_repository.dart';
import 'feature/todo_list/domain/usecases/add_task_uc.dart';
import 'feature/todo_list/domain/usecases/delete_task.dart';
import 'feature/todo_list/domain/usecases/edit_task_uc.dart';
import 'feature/todo_list/domain/usecases/get_filtered_task.dart';
import 'feature/todo_list/domain/usecases/update_task_status.dart';
import 'feature/todo_list/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => TaskBloc(
      getFilteredTasks: sl(),
      addTask: sl(),
      editTask: sl(),
      deleteTask: sl(),
      updateTaskStatus: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetFilteredTasks(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => EditTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatus(sl()));

  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));

  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sl()),
  );

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  final taskBox = await Hive.openBox<TaskModel>(taskBoxName);
  sl.registerLazySingleton<Box<TaskModel>>(() => taskBox);
}

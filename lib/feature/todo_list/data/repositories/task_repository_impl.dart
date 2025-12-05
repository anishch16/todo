import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Tasks>>> getAllTasks() async {
    try {
      final taskModels = await localDataSource.getAllTasks();
      final List<Tasks> tasks = List<Tasks>.from(taskModels);

      return Right(tasks);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addTask(Tasks task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.saveTask(taskModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(Tasks task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      await localDataSource.updateTask(taskModel);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await localDataSource.deleteTask(id);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

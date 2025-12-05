import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Tasks>>> getAllTasks();

  Future<Either<Failure, void>> addTask(Tasks task);

  Future<Either<Failure, void>> updateTask(Tasks task);

  Future<Either<Failure, void>> deleteTask(String id);
}

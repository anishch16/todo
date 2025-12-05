import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class EditTask implements UseCase<void, Tasks> {
  final TaskRepository repository;

  EditTask(this.repository);
  @override
  Future<Either<Failure, void>> call(Tasks task) {
    return repository.updateTask(task);
  }
}

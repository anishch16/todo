import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../presentation/utils.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetFilteredTasks implements UseCase<List<Tasks>, FilterParams> {
  final TaskRepository repository;

  const GetFilteredTasks(this.repository);

  @override
  Future<Either<Failure, List<Tasks>>> call(FilterParams params) async {
    final result = await repository.getAllTasks();

    return result.fold((failure) => Left(failure), (tasks) {
      final List<Tasks> domainTasks = tasks;
      List<Tasks> filteredTasks = domainTasks.where((task) {
        if (params.filter == TaskFilter.active) {
          return !task.isCompleted;
        } else if (params.filter == TaskFilter.completed) {
          return task.isCompleted;
        }
        return true;
      }).toList();
      filteredTasks.sort((a, b) {
        if (a.dueDate != null && b.dueDate != null) {
          return a.dueDate!.compareTo(b.dueDate!);
        } else if (a.dueDate != null) {
          return -1;
        } else if (b.dueDate != null) {
          return 1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });

      return Right(filteredTasks);
    });
  }
}

class FilterParams extends Equatable {
  final TaskFilter filter;

  const FilterParams({this.filter = TaskFilter.all});

  @override
  List<Object?> get props => [filter];
}

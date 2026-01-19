import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mmas_money_tracker/features/tasks/data/repositories/task_repository.dart';
import 'package:mmas_money_tracker/features/tasks/domain/models/financial_task.dart';

final taskListProvider = StreamProvider<List<FinancialTask>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return repository.watchTasks();
});

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final FinancialTaskRepository _repository;

  TaskNotifier(this._repository) : super(const AsyncData(null));

  Future<void> addTask({
    required String title,
    required DateTime dueDate,
    required String priority,
  }) async {
    state = const AsyncLoading();
    try {
      final task = FinancialTask(
        title: title,
        dueDate: dueDate,
        priority: priority,
      );
      await _repository.addTask(task);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleComplete(FinancialTask task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _repository.updateTask(updatedTask);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final taskControllerProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mmas_money_tracker/features/tasks/domain/models/financial_task.dart';

class FinancialTaskRepository {
  static const String boxName = 'financial_tasks';

  Future<Box<FinancialTask>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<FinancialTask>(boxName);
    } else {
      return await Hive.openBox<FinancialTask>(boxName);
    }
  }

  Future<void> addTask(FinancialTask task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  Future<void> updateTask(FinancialTask task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Stream<List<FinancialTask>> watchTasks() async* {
    final box = await _getBox();
    yield box.values.toList();
    yield* box.watch().map((event) => box.values.toList());
  }
}

final taskRepositoryProvider = Provider<FinancialTaskRepository>((ref) {
  return FinancialTaskRepository();
});

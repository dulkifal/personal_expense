import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mmas_money_tracker/features/expenses/domain/models/expense.dart';

class ExpenseRepository {
  static const String boxName = 'expenses';

  Future<Box<Expense>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Expense>(boxName);
    } else {
      return await Hive.openBox<Expense>(boxName);
    }
  }

  Future<void> addExpense(Expense expense) async {
    final box = await _getBox();
    await box.put(expense.id, expense);
  }

  Future<void> deleteExpense(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Future<void> updateExpense(Expense expense) async {
    final box = await _getBox();
    await box.put(expense.id, expense);
  }

  Future<List<Expense>> getAllExpenses() async {
    final box = await _getBox();
    return box.values.toList();
  }
  
  // Stream for real-time updates
  Stream<List<Expense>> watchExpenses() async* {
    final box = await _getBox();
    yield box.values.toList();
    yield* box.watch().map((event) => box.values.toList());
  }
}

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

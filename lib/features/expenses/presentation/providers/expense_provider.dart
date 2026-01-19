import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mmas_money_tracker/features/expenses/data/repositories/expense_repository.dart';
import 'package:mmas_money_tracker/features/expenses/domain/models/expense.dart';

final expenseListProvider = StreamProvider<List<Expense>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.watchExpenses();
});

class ExpenseNotifier extends StateNotifier<AsyncValue<void>> {
  final ExpenseRepository _repository;

  ExpenseNotifier(this._repository) : super(const AsyncData(null));

  Future<void> addExpense({
    required String title,
    required double amount,
    required DateTime date,
    required String category,
    String? note,
  }) async {
    state = const AsyncLoading();
    try {
      final expense = Expense(
        title: title,
        amount: amount,
        date: date,
        category: category,
        note: note,
      );
      await _repository.addExpense(expense);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteExpense(String id) async {
    state = const AsyncLoading();
    try {
      await _repository.deleteExpense(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    state = const AsyncLoading();
    try {
      await _repository.updateExpense(expense);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final expenseControllerProvider =
    StateNotifierProvider<ExpenseNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(expenseRepositoryProvider);
  return ExpenseNotifier(repository);
});

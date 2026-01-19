import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mmas_money_tracker/features/expenses/presentation/providers/expense_provider.dart';
import 'package:mmas_money_tracker/features/expenses/presentation/widgets/expense_card.dart';
import 'package:mmas_money_tracker/features/expenses/presentation/pages/add_expense_page.dart';
import 'package:mmas_money_tracker/features/expenses/domain/models/expense.dart';

class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.savings_outlined, size: 80, color: theme.colorScheme.primary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses yet!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first expense to get started.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            );
          }
          final sortedExpenses = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
          
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // Space for FAB
            itemCount: sortedExpenses.length,
            itemBuilder: (context, index) {
              final expense = sortedExpenses[index];
              return Dismissible(
                key: Key(expense.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: theme.colorScheme.error,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  ref.read(expenseControllerProvider.notifier).deleteExpense(expense.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${expense.title} dismissed')),
                  );
                },
                child: ExpenseCard(expense: expense),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

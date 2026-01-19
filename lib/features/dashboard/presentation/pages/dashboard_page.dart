import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:mmas_money_tracker/features/expenses/presentation/providers/expense_provider.dart';
import 'package:mmas_money_tracker/features/tasks/presentation/providers/task_provider.dart';
import 'package:mmas_money_tracker/features/expenses/domain/models/expense.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);
    final tasksAsync = ref.watch(taskListProvider);
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: 'Total Spent',
                    value: expensesAsync.maybeWhen(
                      data: (expenses) => currencyFormatter.format(
                        expenses.fold<double>(0, (sum, e) => sum + e.amount),
                      ),
                      orElse: () => '...',
                    ),
                    icon: Icons.account_balance_wallet,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: 'Pending Tasks',
                    value: tasksAsync.maybeWhen(
                      data: (tasks) => tasks.where((t) => !t.isCompleted).length.toString(),
                      orElse: () => '...',
                    ),
                    icon: Icons.assignment_late,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Chart Section
            Text(
              'Spending Breakdown',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: expensesAsync.when(
                data: (expenses) {
                  if (expenses.isEmpty) {
                    return Center(child: Text('No data to display', style: theme.textTheme.bodyMedium));
                  }
                  return _buildPieChart(context, expenses);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Error loading chart')),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent Activity Section (could add more here)
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context,
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 12, color: theme.disabledColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, List<Expense> expenses) {
    final Map<String, double> categoryTotals = {};
    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }

    final List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      final color = _getColorForCategory(entry.key);
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '',
        radius: 60,
        badgeWidget: _Badge(
          entry.key,
          size: 40,
          borderColor: color,
        ),
        badgePositionPercentageOffset: .98,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
  
  Color _getColorForCategory(String category) {
      switch (category.toLowerCase()) {
        case 'food':
          return Colors.orangeAccent;
        case 'transport':
          return Colors.blueAccent;
        case 'shopping':
          return Colors.pinkAccent;
        case 'entertainment':
          return Colors.purpleAccent;
        case 'bills':
          return Colors.redAccent;
        default:
          return Colors.grey;
      }
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final double size;
  final Color borderColor;

  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), 
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: FittedBox(
          child: Icon(
            _getIconForCategory(text),
            color: borderColor,
          ),
        ),
      ),
    );
  }
  
  IconData _getIconForCategory(String category) {
      switch (category.toLowerCase()) {
        case 'food':
          return Icons.fastfood;
        case 'transport':
          return Icons.directions_car;
        case 'shopping':
          return Icons.shopping_bag;
        case 'entertainment':
          return Icons.movie;
        case 'bills':
          return Icons.receipt;
        default:
          return Icons.category;
      }
    }
}

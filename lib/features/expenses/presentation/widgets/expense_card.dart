import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.simpleCurrency();
    final dateFormat = DateFormat.yMMMd();

    // Determine icon based on category (Simple logic for now)
    IconData _getIconForCategory(String category) {
      switch (category.toLowerCase()) {
        case 'food':
          return Icons.fastfood_rounded;
        case 'transport':
          return Icons.directions_car_rounded;
        case 'shopping':
          return Icons.shopping_bag_rounded;
        case 'entertainment':
          return Icons.movie_rounded;
        case 'bills':
          return Icons.receipt_long_rounded;
        default:
          return Icons.attach_money_rounded;
      }
    }

    // Determine color based on category
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
          return theme.colorScheme.primary;
      }
    }

    final categoryColor = _getColorForCategory(expense.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: categoryColor.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                theme.cardTheme.color ?? theme.cardColor,
                theme.cardTheme.color?.withOpacity(0.9) ?? theme.cardColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForCategory(expense.category),
                  color: categoryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(expense.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                currencyFormat.format(expense.amount),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: expense.category.toLowerCase() == 'income' 
                      ? Colors.green 
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

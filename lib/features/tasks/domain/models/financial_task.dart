import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'financial_task.g.dart';

@HiveType(typeId: 1)
class FinancialTask {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String priority; // High, Medium, Low

  FinancialTask({
    String? id,
    required this.title,
    this.isCompleted = false,
    required this.dueDate,
    this.priority = 'Medium',
  }) : id = id ?? const Uuid().v4();

  FinancialTask copyWith({
    String? title,
    bool? isCompleted,
    DateTime? dueDate,
    String? priority,
  }) {
    return FinancialTask(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}

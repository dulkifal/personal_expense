import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mmas_money_tracker/features/tasks/presentation/providers/task_provider.dart';
import 'package:mmas_money_tracker/features/tasks/domain/models/financial_task.dart';

class FinancialTaskListPage extends ConsumerStatefulWidget {
  const FinancialTaskListPage({super.key});

  @override
  ConsumerState<FinancialTaskListPage> createState() => _FinancialTaskListPageState();
}

class _FinancialTaskListPageState extends ConsumerState<FinancialTaskListPage> {
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedPriority = 'Medium';
    // Using a list for priorities
    final priorities = ['High', 'Medium', 'Low'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New Financial Task',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20),
                              const SizedBox(width: 8),
                              Text(DateFormat.yMMMd().format(selectedDate)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        items: priorities.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                        onChanged: (val) {
                          setModalState(() => selectedPriority = val!);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      ref.read(taskControllerProvider.notifier).addTask(
                            title: titleController.text,
                            dueDate: selectedDate,
                            priority: selectedPriority,
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Task'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListProvider);
    final theme = Theme.of(context);

    // Filter Logic can be added here (e.g., active vs completed tabs)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Tasks'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add_task),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text('No tasks set.', style: theme.textTheme.titleMedium?.copyWith(color: theme.disabledColor)),
                ],
              ),
            );
          }
          final sortedTasks = [...tasks]
            ..sort((a, b) => a.isCompleted == b.isCompleted 
                ? a.dueDate.compareTo(b.dueDate) 
                : (a.isCompleted ? 1 : -1));

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: sortedTasks.length,
            itemBuilder: (context, index) {
              final task = sortedTasks[index];
              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ref.read(taskControllerProvider.notifier).deleteTask(task.id);
                },
                background: Container(
                  color: theme.colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) {
                        ref.read(taskControllerProvider.notifier).toggleComplete(task);
                      },
                      shape: const CircleBorder(),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? theme.disabledColor : null,
                      ),
                    ),
                    subtitle: Text(
                      'Due: ${DateFormat.yMMMd().format(task.dueDate)} • ${task.priority}',
                      style: TextStyle(
                        color: task.isCompleted ? theme.disabledColor : null,
                      ),
                    ),
                    trailing: _buildPriorityBadge(task.priority, theme),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority, ThemeData theme) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.redAccent;
        break;
      case 'Medium':
        color = Colors.orangeAccent;
        break;
      case 'Low':
        color = Colors.greenAccent;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

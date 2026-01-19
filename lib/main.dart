import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/expenses/domain/models/expense.dart';
import 'features/tasks/domain/models/financial_task.dart';
import 'features/core/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(FinancialTaskAdapter());
  
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<FinancialTask>('financial_tasks');

  runApp(const ProviderScope(child: MMASMoneyTrackerApp()));
}

class MMASMoneyTrackerApp extends StatelessWidget {
  const MMASMoneyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MMAS Money Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainPage(),
    );
  }
}

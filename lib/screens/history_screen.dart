import '../utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/history_cubit.dart';
import '../database/equation_model.dart';
import '../states/history_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryCubit>().loadCalculations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История расчетов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<HistoryCubit>().loadCalculations(),
            tooltip: 'Обновить',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Очистить всю историю'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart),
                    SizedBox(width: 8),
                    Text('Статистика'),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'clear') {
                _showClearConfirmationDialog(context);
              } else if (value == 'stats') {
                _showStatisticsDialog(context);
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is HistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(state.message),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<HistoryCubit>().loadCalculations(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }
          
          if (state is HistoryLoaded) {
            final calculations = state.calculations;
            
            if (calculations.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Нет сохраненных расчетов',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Выполните расчеты на главном экране',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Найдено расчетов: ${calculations.length}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: calculations.length,
                    itemBuilder: (context, index) {
                      return _buildCalculationCard(calculations[index], context);
                    },
                  ),
                ),
              ],
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCalculationCard(EquationCalculation calc, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    calc.equationString,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _showDeleteDialog(context, calc.id!),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Коэффициенты: a=${calc.a}, b=${calc.b}, c=${calc.c}'),
            const SizedBox(height: 4),
            Text('Дискриминант: D = ${calc.discriminant.toStringAsFixed(4)}'),
            const SizedBox(height: 4),
            Text('Тип решения: ${calc.solutionType}'),
            const SizedBox(height: 4),
            Text('Корни: ${calc.roots.join(', ')}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: #${calc.id}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  _formatDate(calc.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
           '${date.month.toString().padLeft(2, '0')}.'
           '${date.year} '
           '${date.hour.toString().padLeft(2, '0')}:'
           '${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить расчет?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<HistoryCubit>().deleteCalculation(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Расчет удален'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить всю историю?'),
        content: const Text('Все сохраненные расчеты будут удалены безвозвратно.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<HistoryCubit>().clearAllHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Вся история очищена'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Очистить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog(BuildContext context) async {
    final stats = await context.read<HistoryCubit>().getStatistics();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Статистика расчетов'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildStatRow('Всего выполнено расчетов:', '${stats['total_calculations']}'),
            _buildStatRow('Сохранено в истории:', '${stats['saved_in_db']}'),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Данные из SharedPreferences:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: SharedPrefsHelper.getLastCoefficients(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final coefs = snapshot.data!;
                  return Text('Последние коэффициенты: '
                      'a=${coefs[0]}, b=${coefs[1]}, c=${coefs[2]}');
                }
                return const Text('Нет сохраненных коэффициентов');
              },
            ),
            FutureBuilder(
              future: SharedPrefsHelper.getAgreementStatus(),
              builder: (context, snapshot) {
                return Text('Согласие на обработку: '
                    '${snapshot.data ?? false ? 'Да' : 'Нет'}');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
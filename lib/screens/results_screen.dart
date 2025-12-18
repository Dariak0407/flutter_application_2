import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/history_cubit.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../database/equation_model.dart';
import '../cubits/history_cubit.dart';
import '../utils/shared_prefs_helper.dart';

class ResultsScreen extends StatelessWidget {
  final double a;
  final double b;
  final double c;

  const ResultsScreen({
    super.key,
    required this.a,
    required this.b,
    required this.c,
  });

  Map<String, dynamic> calculateRoots() {
    // Вычисление дискриминанта
    double discriminant = b * b - 4 * a * c;
    
    String equation = '${a}x² ${b >= 0 ? '+' : '-'} ${b.abs()}x ${c >= 0 ? '+' : '-'} ${c.abs()} = 0';
    
    List<String> roots = [];
    String solutionType = '';
    
    if (discriminant > 0) {
      solutionType = 'Два различных вещественных корня';
      double x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      double x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      roots.add('x₁ = ${x1.toStringAsFixed(4)}');
      roots.add('x₂ = ${x2.toStringAsFixed(4)}');
    } else if (discriminant == 0) {
      solutionType = 'Один вещественный корень (кратности 2)';
      double x = -b / (2 * a);
      roots.add('x = ${x.toStringAsFixed(4)}');
    } else {
      solutionType = 'Два комплексных корня';
      double realPart = -b / (2 * a);
      double imaginaryPart = math.sqrt(-discriminant) / (2 * a);
      roots.add('x₁ = ${realPart.toStringAsFixed(4)} + ${imaginaryPart.toStringAsFixed(4)}i');
      roots.add('x₂ = ${realPart.toStringAsFixed(4)} - ${imaginaryPart.toStringAsFixed(4)}i');
    }
    
    return {
      'equation': equation,
      'discriminant': discriminant,
      'solutionType': solutionType,
      'roots': roots,
    };
  }

  Future<void> _saveToHistory(BuildContext context) async {
    final results = calculateRoots();
    
    final calculation = EquationCalculation(
      a: a,
      b: b,
      c: c,
      equationString: results['equation'],
      discriminant: results['discriminant'],
      solutionType: results['solutionType'],
      roots: results['roots'],
      createdAt: DateTime.now(),
    );

    // Получаем HistoryCubit через context
    final historyCubit = BlocProvider.of<HistoryCubit>(context);
    await historyCubit.saveCalculation(calculation);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Расчет сохранен в истории'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> results = calculateRoots();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты расчета'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Результаты решения квадратного уравнения:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            
            // Карточка с уравнением
            Card(
              color: Colors.blue[50],
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Уравнение:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      results['equation'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Коэффициенты:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text('a = $a, b = $b, c = $c'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Карточка с результатами
            Card(
              color: Colors.green[50],
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Результаты:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Дискриминант: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('D = ${results['discriminant'].toStringAsFixed(4)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Тип решения: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(results['solutionType'])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Корни уравнения:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...results['roots'].map<Widget>((root) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $root'),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Кнопка сохранения
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _saveToHistory(context),
                icon: const Icon(Icons.save),
                label: const Text(
                  'Сохранить в историю',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Информация о сохранении
            const Card(
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.white),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Расчет будет сохранен в локальной базе данных и доступен в разделе "История"',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
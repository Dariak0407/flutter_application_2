// lib/screens/equation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadratic_solver/states/equation_state.dart';
import 'package:quadratic_solver/screens/equation_cubit.dart';

class EquationScreen extends StatefulWidget {
  const EquationScreen({super.key});

  @override
  State<EquationScreen> createState() => _EquationScreenState();
}

class _EquationScreenState extends State<EquationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  bool _agreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лабораторная работа 4'),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Козлова Дарья',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<EquationCubit, EquationState>(
          builder: (context, state) {
            if (state is EquationInitial || state is EquationError) {
              return _buildInputForm(context, state is EquationError ? state.message : null);
            }

            if (state is EquationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EquationSuccess) {
              return _buildResultView(context, state);
            }

            return const Center(child: Text('Неизвестное состояние'));
          },
        ),
      ),
    );
  }

  Widget _buildInputForm(BuildContext context, String? errorMessage) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Решение квадратного уравнения',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 10),
          const Text('Введите коэффициенты уравнения ax² + bx + c = 0'),
          const SizedBox(height: 20),

          TextFormField(
            controller: _aController,
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: const InputDecoration(
              labelText: 'Коэффициент a',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Введите a';
              final num = double.tryParse(value);
              if (num == null) return 'Введите корректное число';
              if (num == 0) return 'a не может быть 0';
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _bController,
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: const InputDecoration(
              labelText: 'Коэффициент b',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Введите b';
              if (double.tryParse(value) == null) return 'Введите корректное число';
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _cController,
            keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
            decoration: const InputDecoration(
              labelText: 'Коэффициент c',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.numbers),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Введите c';
              if (double.tryParse(value) == null) return 'Введите корректное число';
              return null;
            },
          ),
          const SizedBox(height: 20),

          Card(
            child: CheckboxListTile(
              title: const Text(
                'Согласие на обработку персональных данных',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Для выполнения расчета необходимо ваше согласие'),
              value: _agreementChecked,
              onChanged: (bool? value) {
                setState(() {
                  _agreementChecked = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),

          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 30),

          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (!_agreementChecked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Необходимо согласие на обработку данных'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final a = double.parse(_aController.text);
                  final b = double.parse(_bController.text);
                  final c = double.parse(_cController.text);

                  context.read<EquationCubit>().calculate(a, b, c);
                }
              },
              icon: const Icon(Icons.calculate),
              label: const Text('Рассчитать корни уравнения'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView(BuildContext context, EquationSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Результаты решения квадратного уравнения:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 20),

        _buildCard('Уравнение:', state.equation, Colors.blue),
        const SizedBox(height: 15),
        _buildCard('Дискриминант:', 'D = b² - 4ac = ${state.discriminant.toStringAsFixed(4)}', Colors.orange),
        const SizedBox(height: 15),
        _buildCard('Тип решения:', state.solutionType, Colors.purple),
        const SizedBox(height: 15),

        Card(
          color: Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Корни уравнения:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 10),
                ...state.roots.map((root) => Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(root, style: const TextStyle(fontSize: 16)),
                    )),
              ],
            ),
          ),
        ),

        const Spacer(),

        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // Сброс ввода и состояния
              _aController.clear();
              _bController.clear();
              _cController.clear();
              _agreementChecked = false;
              context.read<EquationCubit>().reset();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Новое уравнение'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              backgroundColor: Colors.blue,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCard(String title, String content, MaterialColor color) {
    return Card(
      color: color[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 5),
            Text(content, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }
}
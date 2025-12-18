import 'package:flutter/material.dart';
import 'results_screen.dart';
import 'history_screen.dart';
import '../utils/shared_prefs_helper.dart';

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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLastCoefficients();
    _loadAgreementStatus();
  }

  Future<void> _loadLastCoefficients() async {
    final coefficients = await SharedPrefsHelper.getLastCoefficients();
    if (coefficients != null && mounted) {
      setState(() {
        _aController.text = coefficients[0].toString();
        _bController.text = coefficients[1].toString();
        _cController.text = coefficients[2].toString();
      });
    }
  }

  Future<void> _loadAgreementStatus() async {
    final agreed = await SharedPrefsHelper.getAgreementStatus();
    if (mounted) {
      setState(() {
        _agreementChecked = agreed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Квадратное уравнение'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
            tooltip: 'История расчетов',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Решение квадратного уравнения',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Введите коэффициенты уравнения ax² + bx + c = 0',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 25),

                // Поле для коэффициента a
                TextFormField(
                  controller: _aController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Коэффициент a',
                    border: const OutlineInputBorder(),
                    hintText: 'Введите a',
                    prefixIcon: const Icon(Icons.numbers),
                    suffixIcon: _aController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => _aController.clear(),
                          )
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите коэффициент a';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Введите корректное число';
                    }
                    if (double.parse(value) == 0) {
                      return 'Коэффициент a не может быть 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле для коэффициента b
                TextFormField(
                  controller: _bController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Коэффициент b',
                    border: const OutlineInputBorder(),
                    hintText: 'Введите b',
                    prefixIcon: const Icon(Icons.numbers),
                    suffixIcon: _bController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => _bController.clear(),
                          )
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите коэффициент b';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Введите корректное число';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Поле для коэффициента c
                TextFormField(
                  controller: _cController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Коэффициент c',
                    border: const OutlineInputBorder(),
                    hintText: 'Введите c',
                    prefixIcon: const Icon(Icons.numbers),
                    suffixIcon: _cController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () => _cController.clear(),
                          )
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите коэффициент c';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Введите корректное число';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Чек-бокс согласия
                Card(
                  elevation: 2,
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
                      SharedPrefsHelper.saveAgreementStatus(value ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 30),

                // Кнопка расчета
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: _calculateEquation,
                          icon: const Icon(Icons.calculate),
                          label: const Text(
                            'Рассчитать корни уравнения',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            backgroundColor: Colors.blue,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // Статистика
                FutureBuilder(
                  future: SharedPrefsHelper.getCalculationCount(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        color: Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.countertops, color: Colors.blue),
                              const SizedBox(width: 10),
                              Text(
                                'Всего выполнено расчетов: ${snapshot.data}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _calculateEquation() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreementChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Необходимо согласие на обработку данных'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final a = double.parse(_aController.text);
        final b = double.parse(_bController.text);
        final c = double.parse(_cController.text);

        // Сохраняем коэффициенты
        await SharedPrefsHelper.saveLastCoefficients(a, b, c);
        await SharedPrefsHelper.incrementCalculationCount();

        // Переход на экран результатов
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                a: a,
                b: b,
                c: c,
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }
}
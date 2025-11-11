import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторная работа 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuadraticEquationScreen(),
    );
  }
}

class QuadraticEquationScreen extends StatefulWidget {
  @override
  _QuadraticEquationScreenState createState() => _QuadraticEquationScreenState();
}

class _QuadraticEquationScreenState extends State<QuadraticEquationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  bool _agreementChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Лабораторная работа 3'),
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Козлова Дарья',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Решение квадратного уравнения',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Введите коэффициенты уравнения ax² + bx + c = 0',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              
              // Поле для коэффициента a
              TextFormField(
                controller: _aController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Коэффициент a',
                  border: OutlineInputBorder(),
                  hintText: 'Введите a',
                  prefixIcon: Icon(Icons.numbers),
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
              SizedBox(height: 16),
              
              // Поле для коэффициента b
              TextFormField(
                controller: _bController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Коэффициент b',
                  border: OutlineInputBorder(),
                  hintText: 'Введите b',
                  prefixIcon: Icon(Icons.numbers),
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
              SizedBox(height: 16),
              
              // Поле для коэффициента c
              TextFormField(
                controller: _cController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Коэффициент c',
                  border: OutlineInputBorder(),
                  hintText: 'Введите c',
                  prefixIcon: Icon(Icons.numbers),
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
              SizedBox(height: 20),
              
              // Чек-бокс согласия на обработку данных
              Card(
                child: CheckboxListTile(
                  title: Text(
                    'Согласие на обработку персональных данных',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Для выполнения расчета необходимо ваше согласие'),
                  value: _agreementChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreementChecked = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.blue,
                ),
              ),
              
              SizedBox(height: 30),
              
              // Кнопка расчета
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_agreementChecked) {
                        // Переход на второй экран с передачей параметров
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsScreen(
                              a: double.parse(_aController.text),
                              b: double.parse(_bController.text),
                              c: double.parse(_cController.text),
                            ),
                          ),
                        );
                      } else {
                        // Показать ошибку если чек-бокс не отмечен
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Необходимо согласие на обработку данных'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(Icons.calculate),
                  label: Text(
                    'Рассчитать корни уравнения',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
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

class ResultsScreen extends StatelessWidget {
  final double a;
  final double b;
  final double c;

  const ResultsScreen({
    Key? key,
    required this.a,
    required this.b,
    required this.c,
  }) : super(key: key);

  Map<String, dynamic> calculateRoots() {
    // Вычисление дискриминанта
    double discriminant = b * b - 4 * a * c;
    
    String equation = '${a}x² ${b >= 0 ? '+' : ''} ${b}x ${c >= 0 ? '+' : ''} ${c} = 0';
    
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

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> results = calculateRoots();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты расчета'),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Козлова Д.А.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Результаты решения квадратного уравнения:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            
            // Карточка с уравнением
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Уравнение:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      results['equation'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            
            // Карточка с дискриминантом
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дискриминант:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'D = b² - 4ac = ${results['discriminant'].toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            
            // Карточка с типом решения
            Card(
              color: Colors.purple[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тип решения:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      results['solutionType'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            
            // Карточка с корнями
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Корни уравнения:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (results['roots'] as List<String>)
                          .map((root) => Padding(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: Text(
                                  root,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            Spacer(),
            
            // Кнопка возврата
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Вернуться к вводу данных'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
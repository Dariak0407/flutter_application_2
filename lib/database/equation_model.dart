class EquationCalculation {
  int? id;
  double a;
  double b;
  double c;
  String equationString;
  double discriminant;
  String solutionType;
  List<String> roots;
  DateTime createdAt;

  EquationCalculation({
    this.id,
    required this.a,
    required this.b,
    required this.c,
    required this.equationString,
    required this.discriminant,
    required this.solutionType,
    required this.roots,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'a': a,
      'b': b,
      'c': c,
      'equation_string': equationString,
      'discriminant': discriminant,
      'solution_type': solutionType,
      'roots': roots.join('|'), // Сохраняем список как строку
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory EquationCalculation.fromMap(Map<String, dynamic> map) {
    return EquationCalculation(
      id: map['id'],
      a: map['a'],
      b: map['b'],
      c: map['c'],
      equationString: map['equation_string'],
      discriminant: map['discriminant'],
      solutionType: map['solution_type'],
      roots: (map['roots'] as String).split('|'),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  @override
  String toString() {
    return 'EquationCalculation{id: $id, уравнение: $equationString}';
  }
}
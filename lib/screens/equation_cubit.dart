// lib/screens/equation_cubit.dart

import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quadratic_solver/states/equation_state.dart';

class EquationCubit extends Cubit<EquationState> {
  EquationCubit() : super(EquationInitial());

  void calculate(double a, double b, double c) {
    if (a == 0) {
      emit(EquationError('Коэффициент "a" не может быть равен нулю.'));
      return;
    }

    emit(EquationLoading());

    final discriminant = b * b - 4 * a * c;
    final equation = '${a}x² ${b >= 0 ? '+' : ''} ${b}x ${c >= 0 ? '+' : ''} ${c} = 0';

    List<String> roots = [];
    String solutionType = '';

    if (discriminant > 0) {
      solutionType = 'Два различных вещественных корня';
      final x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      final x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      roots.add('x₁ = ${x1.toStringAsFixed(4)}');
      roots.add('x₂ = ${x2.toStringAsFixed(4)}');
    } else if (discriminant == 0) {
      solutionType = 'Один вещественный корень (кратности 2)';
      final x = -b / (2 * a);
      roots.add('x = ${x.toStringAsFixed(4)}');
    } else {
      solutionType = 'Два комплексных корня';
      final realPart = -b / (2 * a);
      final imaginaryPart = math.sqrt(-discriminant) / (2 * a);
      roots.add('x₁ = ${realPart.toStringAsFixed(4)} + ${imaginaryPart.toStringAsFixed(4)}i');
      roots.add('x₂ = ${realPart.toStringAsFixed(4)} - ${imaginaryPart.toStringAsFixed(4)}i');
    }

    emit(
      EquationSuccess(
        equation: equation,
        discriminant: discriminant,
        solutionType: solutionType,
        roots: roots,
      ),
    );
  }

  void reset() {
    emit(EquationInitial());
  }
}
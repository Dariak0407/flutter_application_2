// lib/states/equation_state.dart

abstract class EquationState {}

class EquationInitial extends EquationState {}

class EquationLoading extends EquationState {}

class EquationSuccess extends EquationState {
  final String equation;
  final double discriminant;
  final String solutionType;
  final List<String> roots;

  EquationSuccess({
    required this.equation,
    required this.discriminant,
    required this.solutionType,
    required this.roots,
  });
}

class EquationError extends EquationState {
  final String message;

  EquationError(this.message);
}
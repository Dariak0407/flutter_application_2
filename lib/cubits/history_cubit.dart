import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/db_provider.dart';
import '../database/equation_model.dart';
import '../states/history_state.dart';
import '../utils/shared_prefs_helper.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final DBProvider _dbProvider;
  
  HistoryCubit() : _dbProvider = DBProvider(), super(HistoryInitial());

  // Загрузить все расчеты
  Future<void> loadCalculations() async {
    emit(HistoryLoading());
    try {
      final calculations = await _dbProvider.getAllCalculations();
      emit(HistoryLoaded(calculations));
    } catch (e) {
      emit(HistoryError('Ошибка загрузки данных: ${e.toString()}'));
    }
  }

  // Сохранить новый расчет
  Future<void> saveCalculation(EquationCalculation calc) async {
    try {
      await _dbProvider.insertCalculation(calc);
      await SharedPrefsHelper.incrementCalculationCount();
      
      // Обновляем список, если он уже загружен
      final currentState = state;
      if (currentState is HistoryLoaded) {
        final updatedList = [calc, ...currentState.calculations];
        emit(HistoryLoaded(updatedList));
      }
    } catch (e) {
      print('Ошибка сохранения расчета: $e');
    }
  }

  // Удалить расчет
  Future<void> deleteCalculation(int id) async {
    try {
      await _dbProvider.deleteCalculation(id);
      
      // Обновляем состояние
      final currentState = state;
      if (currentState is HistoryLoaded) {
        final updatedList = currentState.calculations
            .where((calc) => calc.id != id)
            .toList();
        emit(HistoryLoaded(updatedList));
      }
    } catch (e) {
      emit(HistoryError('Ошибка удаления: ${e.toString()}'));
    }
  }

  // Очистить всю историю
  Future<void> clearAllHistory() async {
    try {
      await _dbProvider.clearAllCalculations();
      emit(HistoryLoaded([]));
    } catch (e) {
      emit(HistoryError('Ошибка очистки: ${e.toString()}'));
    }
  }

  // Получить статистику
  Future<Map<String, dynamic>> getStatistics() async {
    final count = await SharedPrefsHelper.getCalculationCount();
    final currentState = state;
    int savedCount = 0;
    
    if (currentState is HistoryLoaded) {
      savedCount = currentState.calculations.length;
    }
    
    return {
      'total_calculations': count,
      'saved_in_db': savedCount,
    };
  }
}
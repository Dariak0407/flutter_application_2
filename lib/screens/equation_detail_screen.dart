import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/equation_cubit.dart';
import 'cubits/equation_state.dart'; 
import 'cubits/history_cubit.dart';
import 'screens/equation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EquationCubit>(
          create: (context) => EquationCubit(),
          
        ),
        BlocProvider<HistoryCubit>(
          create: (context) => HistoryCubit(),
        ),
      ],
      child: BlocBuilder<EquationCubit, EquationState>(
        builder: (context, state) {
          bool isDarkTheme = false;
          
          if (state is SettingsLoaded) {
            isDarkTheme = state.isDarkTheme;
          } else if (state is ThemeUpdated) {
            isDarkTheme = state.isDarkTheme;
          }
          
          return MaterialApp(
            title: 'Квадратное уравнение',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            home: const EquationScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
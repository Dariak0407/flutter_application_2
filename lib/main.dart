import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
<<<<<<< HEAD
import 'cubits/crypto_cubit.dart';
import 'screens/crypto_screen.dart';
=======
import 'screens/equation_screen.dart';
import 'cubits/history_cubit.dart';
>>>>>>> e88acab4d649dc6f1f96839d9de90755728575da

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return BlocProvider(
      create: (context) => CryptoCubit(),
      child: MaterialApp(
        title: 'Crypto Tracker',
        theme: ThemeData(
          primaryColor: Colors.blueGrey[900],
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey,
            primary: Colors.blueGrey[900]!,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey[900],
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
          ),
        ),
        home: const CryptoScreen(),
        debugShowCheckedModeBanner: false,
=======
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HistoryCubit()),
      ],
      child: MaterialApp(
        title: 'Квадратное уравнение - Лабораторная работа 5',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 2,
          ),
        ),
        home: const EquationScreen(),
>>>>>>> e88acab4d649dc6f1f96839d9de90755728575da
      ),
    );
  }
}
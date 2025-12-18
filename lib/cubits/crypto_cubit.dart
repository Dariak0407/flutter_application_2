import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/coingecko_api.dart';
import '../models/crypto_model.dart';

// Состояния
abstract class CryptoState {}

class CryptoInitial extends CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<CryptoModel> cryptocurrencies;
  
  CryptoLoaded(this.cryptocurrencies);
}

class CryptoError extends CryptoState {
  final String message;
  
  CryptoError(this.message);
}

// Cubit
class CryptoCubit extends Cubit<CryptoState> {
  CryptoCubit() : super(CryptoInitial());

  Future<void> loadCryptocurrencies() async {
    emit(CryptoLoading());
    
    try {
      final cryptos = await CoinGeckoApi.getCryptocurrencies();
      emit(CryptoLoaded(cryptos));
    } catch (e) {
      emit(CryptoError('Failed to load cryptocurrencies: $e'));
    }
  }
}
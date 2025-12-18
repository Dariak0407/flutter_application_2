import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';

class CoinGeckoApi {
  static Future<List<CryptoModel>> getCryptocurrencies() async {
    try {
      final url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets'
        '?vs_currency=usd'
        '&order=market_cap_desc'
        '&per_page=20'
        '&page=1'
        '&sparkline=false'
      );
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CryptoModel.fromJson(json)).toList();
      } else {
        // Возвращаем демо-данные при ошибке
        return getDemoCryptos();
      }
    } catch (e) {
      print('API Error: $e');
      return getDemoCryptos();
    }
  }

  static List<CryptoModel> getDemoCryptos() {
    return [
      CryptoModel(
        id: 'bitcoin',
        symbol: 'BTC',
        name: 'Bitcoin',
        image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
        currentPrice: 45000.00,
        marketCap: 850000000000,
        marketCapRank: 1,
        priceChange24h: 1200.50,
        priceChangePercentage24h: 2.75,
      ),
      CryptoModel(
        id: 'ethereum',
        symbol: 'ETH',
        name: 'Ethereum',
        image: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
        currentPrice: 3200.50,
        marketCap: 385000000000,
        marketCapRank: 2,
        priceChange24h: -50.25,
        priceChangePercentage24h: -1.55,
      ),
      CryptoModel(
        id: 'cardano',
        symbol: 'ADA',
        name: 'Cardano',
        image: 'https://assets.coingecko.com/coins/images/975/large/cardano.png',
        currentPrice: 0.52,
        marketCap: 18500000000,
        marketCapRank: 8,
        priceChange24h: 0.02,
        priceChangePercentage24h: 4.01,
      ),
      CryptoModel(
        id: 'solana',
        symbol: 'SOL',
        name: 'Solana',
        image: 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
        currentPrice: 95.50,
        marketCap: 42000000000,
        marketCapRank: 5,
        priceChange24h: 3.20,
        priceChangePercentage24h: 3.47,
      ),
      CryptoModel(
        id: 'ripple',
        symbol: 'XRP',
        name: 'XRP',
        image: 'https://assets.coingecko.com/coins/images/44/large/xrp.png',
        currentPrice: 0.62,
        marketCap: 33500000000,
        marketCapRank: 6,
        priceChange24h: 0.01,
        priceChangePercentage24h: 1.64,
      ),
    ];
  }
}
import 'package:flutter/material.dart';

class CryptoModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double priceChange24h;
  final double priceChangePercentage24h;

  CryptoModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'] ?? '',
      symbol: (json['symbol'] ?? '').toUpperCase(),
      name: json['name'] ?? 'Unknown',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0.0).toDouble(),
      marketCap: (json['market_cap'] ?? 0.0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
      priceChange24h: (json['price_change_24h'] ?? 0.0).toDouble(),
      priceChangePercentage24h: 
          (json['price_change_percentage_24h'] ?? 0.0).toDouble(),
    );
  }

  Color get priceChangeColor {
    if (priceChangePercentage24h > 0) {
      return Colors.green;
    } else if (priceChangePercentage24h < 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  IconData get priceChangeIcon {
    if (priceChangePercentage24h > 0) {
      return Icons.trending_up;
    } else if (priceChangePercentage24h < 0) {
      return Icons.trending_down;
    } else {
      return Icons.trending_flat;
    }
  }

  String get formattedPrice {
    if (currentPrice >= 1) {
      return '\$${currentPrice.toStringAsFixed(2)}';
    } else {
      return '\$${currentPrice.toStringAsFixed(6)}';
    }
  }

  String get formattedPriceChange {
    return '${priceChangePercentage24h.toStringAsFixed(2)}%';
  }
}
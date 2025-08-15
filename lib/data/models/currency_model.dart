import '../../domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.id,
    required super.name,
    required super.symbol,
    required super.type,
  });

  CurrencyModel copyWith({
    String? id,
    String? name,
    String? symbol,
    CurrencyType? type,
  }) {
    return CurrencyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      type: type ?? this.type,
    );
  }
}

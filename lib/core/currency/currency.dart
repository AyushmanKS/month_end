import 'dart:ui';

class Currency {
  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });

  final String code;
  final String symbol;
  final String name;
}

class Currencies {
  const Currencies._();

  static const List<Currency> all = [
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
    Currency(code: 'EUR', symbol: '€', name: 'Euro'),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    Currency(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc'),
    Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    Currency(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
    Currency(code: 'AED', symbol: 'AED', name: 'UAE Dirham'),
    Currency(code: 'SAR', symbol: 'SAR', name: 'Saudi Riyal'),
    Currency(code: 'HKD', symbol: 'HK\$', name: 'Hong Kong Dollar'),
    Currency(code: 'NZD', symbol: 'NZ\$', name: 'New Zealand Dollar'),
    Currency(code: 'ZAR', symbol: 'R', name: 'South African Rand'),
    Currency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
    Currency(code: 'RUB', symbol: '₽', name: 'Russian Ruble'),
    Currency(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
    Currency(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
    Currency(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
    Currency(code: 'THB', symbol: '฿', name: 'Thai Baht'),
    Currency(code: 'NGN', symbol: '₦', name: 'Nigerian Naira'),
  ];

  static const Currency fallback = Currency(
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupee',
  );

  static Currency byCode(String code) {
    for (final currency in all) {
      if (currency.code == code) return currency;
    }
    return fallback;
  }

  static String symbolFor(String code) => byCode(code).symbol;

  static const Map<String, String> _countryToCurrency = {
    'IN': 'INR',
    'US': 'USD',
    'GB': 'GBP',
    'JP': 'JPY',
    'AU': 'AUD',
    'CA': 'CAD',
    'CH': 'CHF',
    'CN': 'CNY',
    'SG': 'SGD',
    'AE': 'AED',
    'SA': 'SAR',
    'HK': 'HKD',
    'NZ': 'NZD',
    'ZA': 'ZAR',
    'BR': 'BRL',
    'RU': 'RUB',
    'KR': 'KRW',
    'MY': 'MYR',
    'ID': 'IDR',
    'TH': 'THB',
    'NG': 'NGN',
    'DE': 'EUR',
    'FR': 'EUR',
    'ES': 'EUR',
    'IT': 'EUR',
    'NL': 'EUR',
    'IE': 'EUR',
    'PT': 'EUR',
    'AT': 'EUR',
    'BE': 'EUR',
    'FI': 'EUR',
    'GR': 'EUR',
  };

  static String localeDefault() {
    final country = PlatformDispatcher.instance.locale.countryCode;
    if (country == null) return fallback.code;
    return _countryToCurrency[country.toUpperCase()] ?? fallback.code;
  }
}

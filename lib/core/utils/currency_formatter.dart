import 'package:intl/intl.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrPrecise = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(num value) => _inr.format(value);

  static String formatPrecise(num value) => _inrPrecise.format(value);

  static String compact(num value) =>
      NumberFormat.compactCurrency(locale: 'en_IN', symbol: '₹').format(value);
}

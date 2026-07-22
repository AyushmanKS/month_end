import 'package:intl/intl.dart';
import '../currency/currency.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(num value, {String code = 'INR'}) =>
      NumberFormat.currency(
        symbol: Currencies.symbolFor(code),
        decimalDigits: 0,
      ).format(value);

  static String formatPrecise(num value, {String code = 'INR'}) =>
      NumberFormat.currency(
        symbol: Currencies.symbolFor(code),
        decimalDigits: 2,
      ).format(value);

  static String compact(num value, {String code = 'INR'}) =>
      NumberFormat.compactCurrency(
        symbol: Currencies.symbolFor(code),
      ).format(value);
}

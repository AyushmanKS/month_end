import 'package:intl/intl.dart';

class AppDateUtils {
  const AppDateUtils._();

  static final DateFormat _day = DateFormat('d MMM');
  static final DateFormat _dayYear = DateFormat('d MMM yyyy');
  static final DateFormat _month = DateFormat('MMMM yyyy');

  static String day(DateTime date) => _day.format(date);
  static String dayYear(DateTime date) => _dayYear.format(date);
  static String month(DateTime date) => _month.format(date);

  static DateTime startOfMonth(DateTime date) => DateTime(date.year, date.month);

  static DateTime endOfMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 0);

  static int daysInMonth(DateTime date) => endOfMonth(date).day;

  static List<DateRange> weekWindows(DateTime monthStart) {
    final end = endOfMonth(monthStart);
    final windows = <DateRange>[];
    var cursor = DateTime(monthStart.year, monthStart.month, monthStart.day);
    while (!cursor.isAfter(end)) {
      final windowEnd = _min(cursor.add(const Duration(days: 6)), end);
      windows.add(DateRange(cursor, windowEnd));
      cursor = windowEnd.add(const Duration(days: 1));
    }
    return windows;
  }

  static int remainingWeeksInMonth(DateTime from) {
    final windows = weekWindows(startOfMonth(from));
    return windows.where((w) => !w.end.isBefore(_dateOnly(from))).length;
  }

  static DateTime _min(DateTime a, DateTime b) => a.isBefore(b) ? a : b;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

class DateRange {
  const DateRange(this.start, this.end);

  final DateTime start;
  final DateTime end;
}

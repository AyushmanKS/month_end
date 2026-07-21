import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_providers/supabase_providers.dart';

const _chartTypeKey = 'analytics_chart_type';

enum AppChartType { bar, pie, line, donut }

extension AppChartTypeLabel on AppChartType {
  String get label {
    switch (this) {
      case AppChartType.bar:
        return 'Bar';
      case AppChartType.pie:
        return 'Pie';
      case AppChartType.line:
        return 'Line';
      case AppChartType.donut:
        return 'Donut';
    }
  }
}

class ChartTypeNotifier extends StateNotifier<AppChartType> {
  ChartTypeNotifier(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static AppChartType _read(SharedPreferences prefs) {
    final stored = prefs.getString(_chartTypeKey);
    return AppChartType.values.firstWhere(
      (type) => type.name == stored,
      orElse: () => AppChartType.bar,
    );
  }

  void set(AppChartType type) {
    state = type;
    _prefs.setString(_chartTypeKey, type.name);
  }
}

final chartTypeProvider =
    StateNotifierProvider<ChartTypeNotifier, AppChartType>((ref) {
      return ChartTypeNotifier(ref.watch(sharedPreferencesProvider));
    });

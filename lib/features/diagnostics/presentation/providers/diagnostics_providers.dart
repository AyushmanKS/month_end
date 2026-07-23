import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/app_info/app_info_providers.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/sync/sync_status.dart';

class DiagnosticsSnapshot {
  const DiagnosticsSnapshot({
    required this.version,
    required this.platform,
    required this.online,
    required this.queued,
    required this.failed,
    required this.syncPhase,
  });

  final String version;
  final String platform;
  final bool online;
  final int queued;
  final int failed;
  final String syncPhase;
}

final diagnosticsProvider = FutureProvider.autoDispose<DiagnosticsSnapshot>((
  ref,
) async {
  final info = await ref.watch(packageInfoProvider.future);
  final rows = await ref.watch(outboxRepositoryProvider).pending();
  final failed = rows.where((r) => r.syncState == 'failed').length;
  final sync = ref.watch(syncStatusProvider);
  final online = ref.watch(isOnlineProvider).value ?? false;

  return DiagnosticsSnapshot(
    version: formatAppVersion(info),
    platform: await _describePlatform(),
    online: online,
    queued: rows.length - failed,
    failed: failed,
    syncPhase: sync.phase.name,
  );
});

Future<String> _describePlatform() async {
  if (kIsWeb) {
    try {
      final web = await DeviceInfoPlugin().webBrowserInfo;
      return 'Web · ${web.browserName.name}';
    } catch (_) {
      return 'Web';
    }
  }
  return defaultTargetPlatform.name;
}

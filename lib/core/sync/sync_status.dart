import 'package:flutter_riverpod/legacy.dart';

enum SyncPhase { idle, syncing, failed }

class SyncStatus {
  const SyncStatus({
    this.phase = SyncPhase.idle,
    this.completed = 0,
    this.total = 0,
    this.failed = 0,
  });

  final SyncPhase phase;
  final int completed;
  final int total;
  final int failed;

  bool get isSyncing => phase == SyncPhase.syncing;

  SyncStatus copyWith({
    SyncPhase? phase,
    int? completed,
    int? total,
    int? failed,
  }) {
    return SyncStatus(
      phase: phase ?? this.phase,
      completed: completed ?? this.completed,
      total: total ?? this.total,
      failed: failed ?? this.failed,
    );
  }
}

class SyncStatusNotifier extends StateNotifier<SyncStatus> {
  SyncStatusNotifier() : super(const SyncStatus());

  void begin(int total) => state = SyncStatus(
    phase: SyncPhase.syncing,
    total: total,
    completed: 0,
    failed: 0,
  );

  void progress() => state = state.copyWith(completed: state.completed + 1);

  void fail() => state = state.copyWith(failed: state.failed + 1);

  void finish() => state = state.copyWith(
    phase: state.failed > 0 ? SyncPhase.failed : SyncPhase.idle,
  );

  void idle() => state = const SyncStatus();
}

final syncStatusProvider =
    StateNotifierProvider<SyncStatusNotifier, SyncStatus>((ref) {
      return SyncStatusNotifier();
    });

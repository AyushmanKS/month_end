import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/diagnostics_providers.dart';

class DiagnosticsScreen extends ConsumerWidget {
  const DiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(diagnosticsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(diagnosticsProvider),
          ),
        ],
      ),
      body: SafeArea(
        child: snapshot.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Could not load diagnostics.\n$error')),
          data: (d) => ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _Row(label: 'App version', value: d.version),
              _Row(label: 'Platform', value: d.platform),
              _Row(label: 'Network', value: d.online ? 'Online' : 'Offline'),
              _Row(label: 'Sync state', value: d.syncPhase),
              _Row(label: 'Queued changes', value: '${d.queued}'),
              _Row(label: 'Failed changes', value: '${d.failed}'),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

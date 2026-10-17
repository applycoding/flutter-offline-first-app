import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/inspection.dart';
import '../providers.dart';
import 'inspection_detail_screen.dart';
import 'new_inspection_sheet.dart';
import 'status_chip.dart';

class InspectionListScreen extends ConsumerWidget {
  const InspectionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(onlineProvider);
    final inspections = ref.watch(inspectionsProvider);
    final pending = ref.watch(pendingCountProvider);
    final syncing = ref.watch(syncControllerProvider).running;
    final pendingCount =
        pending.maybeWhen(data: (value) => value, orElse: () => 0);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SiteCheck'),
        actions: [
          IconButton(
            key: const Key('sync-button'),
            tooltip: 'Sync queued changes',
            onPressed: syncing
                ? null
                : () async {
                    final report =
                        await ref.read(syncControllerProvider.notifier).flush();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 1200),
                        content: Text(report.message),
                      ),
                    );
                  },
            icon: Badge(
              isLabelVisible: pendingCount > 0,
              label: pendingCount > 0
                  ? Text('$pendingCount', key: const Key('pending-badge'))
                  : null,
              child: syncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
            ),
          ),
          IconButton(
            key: const Key('connectivity-toggle'),
            tooltip: connection.online
                ? 'Online. Simulate offline.'
                : 'Offline. Go back online.',
            onPressed: () {
              ref.read(onlineProvider.notifier).toggleSimulation();
            },
            icon: Icon(
              connection.online
                  ? Icons.cloud_done_outlined
                  : Icons.cloud_off_outlined,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('new-inspection'),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (context) => const NewInspectionSheet(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Inspection'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: connection.online
                ? scheme.secondaryContainer
                : scheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                connection.online
                    ? 'Online. Queued edits push to the in-memory field server.'
                    : 'Offline. Edits stay in the sync queue on this device.',
              ),
            ),
          ),
          Expanded(
            child: inspections.when(
              loading: () => const Center(
                child:
                    CircularProgressIndicator(key: Key('inspections-loading')),
              ),
              error: (error, stackTrace) => _MessagePane(
                title: 'Could not read inspections',
                detail: '$error',
                action: TextButton(
                  onPressed: () => ref.invalidate(inspectionsProvider),
                  child: const Text('Try again'),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const _MessagePane(
                    title: 'No inspections yet',
                    detail:
                        'No inspections yet. Add a site visit to start a checklist.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final inspection = items[index];
                    return _InspectionCard(inspection: inspection);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectionCard extends ConsumerWidget {
  const _InspectionCard({required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: ValueKey('inspection-${inspection.id}'),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) =>
                  InspectionDetailScreen(inspectionId: inspection.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      inspection.siteName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(status: inspection.status),
                ],
              ),
              const SizedBox(height: 4),
              Text('${inspection.assetId} · ${inspection.inspector}'),
              const SizedBox(height: 8),
              Text(inspection.progressLabel),
              if (inspection.pendingSync || inspection.conflictFlag) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (inspection.pendingSync)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar:
                            const Icon(Icons.cloud_upload_outlined, size: 18),
                        label: const Text('Queued'),
                        side: BorderSide.none,
                        backgroundColor: scheme.surfaceContainerHighest,
                      ),
                    if (inspection.conflictFlag)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: Icon(
                          Icons.flag_outlined,
                          size: 18,
                          color: scheme.onErrorContainer,
                        ),
                        label: const Text('Conflict'),
                        side: BorderSide.none,
                        backgroundColor: scheme.errorContainer,
                      ),
                  ],
                ),
              ],
              if (inspection.syncError != null) ...[
                const SizedBox(height: 8),
                Text(
                  inspection.syncError!,
                  style: TextStyle(color: scheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MessagePane extends StatelessWidget {
  const _MessagePane({required this.title, required this.detail, this.action});

  final String title;
  final String detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(detail, textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}

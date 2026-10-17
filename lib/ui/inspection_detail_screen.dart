import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/inspection.dart';
import '../providers.dart';
import 'labels.dart';
import 'status_chip.dart';

class InspectionDetailScreen extends ConsumerWidget {
  const InspectionDetailScreen({super.key, required this.inspectionId});

  final String inspectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspection = ref.watch(inspectionProvider(inspectionId));
    return inspection.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Could not open this inspection.\n$error')),
      ),
      data: (value) {
        if (value == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Inspection')),
            body: const Center(
                child: Text('This inspection is no longer on the device.')),
          );
        }
        return _DetailBody(inspection: value);
      },
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.inspection});

  final Inspection inspection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final canComplete = inspection.readyToComplete &&
        inspection.status != InspectionStatus.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(inspection.siteName),
        actions: [
          IconButton(
            key: const Key('delete-inspection'),
            tooltip: 'Delete inspection',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete this inspection?'),
                    content: const Text(
                      'It leaves the list on this device and the delete is queued for the server.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        key: const Key('confirm-delete'),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
              if (confirmed != true) return;
              await ref
                  .read(repositoryProvider)
                  .deleteInspection(inspection.id);
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton(
            key: const Key('mark-complete'),
            onPressed: canComplete
                ? () async {
                    final message = await ref
                        .read(repositoryProvider)
                        .markComplete(inspection.id);
                    if (message == null || !context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                : null,
            child: Text(
              inspection.status == InspectionStatus.completed
                  ? 'Checklist complete'
                  : 'Mark complete',
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (inspection.conflictFlag)
            Card(
              color: scheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspection.conflictDetail,
                      key: const Key('conflict-banner'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Last write wins already chose the newer record. Dismiss only clears the flag.',
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        key: const Key('dismiss-conflict'),
                        onPressed: () {
                          ref
                              .read(repositoryProvider)
                              .dismissConflict(inspection.id);
                        },
                        child: const Text('Dismiss flag'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Row(
            children: [
              StatusChip(status: inspection.status),
              const SizedBox(width: 8),
              if (inspection.pendingSync)
                const Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text('Queued'),
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${inspection.assetId} · ${inspection.inspector}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(inspection.progressLabel),
          Text('Updated ${formatStamp(inspection.updatedAt)}'),
          if (inspection.syncError != null) ...[
            const SizedBox(height: 8),
            Text(
              inspection.syncError!,
              style: TextStyle(color: scheme.error),
            ),
          ],
          const SizedBox(height: 16),
          Text('Visit notes', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          _NotesEditor(
            inspectionId: inspection.id,
            notes: inspection.notes,
          ),
          const SizedBox(height: 16),
          Text('Checklist', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final item in inspection.items) ...[
            _ItemTile(item: item),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _NotesEditor extends ConsumerStatefulWidget {
  const _NotesEditor({required this.inspectionId, required this.notes});

  final String inspectionId;
  final String notes;

  @override
  ConsumerState<_NotesEditor> createState() => _NotesEditorState();
}

class _NotesEditorState extends ConsumerState<_NotesEditor> {
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notes);
    _focus = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _NotesEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus && widget.notes != _controller.text) {
      _controller.text = widget.notes;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: const Key('inspection-notes'),
          controller: _controller,
          focusNode: _focus,
          minLines: 2,
          maxLines: 4,
          decoration:
              const InputDecoration(hintText: 'What did you see on site?'),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.tonal(
            key: const Key('save-notes'),
            onPressed: () {
              ref.read(repositoryProvider).updateNotes(
                  id: widget.inspectionId, notes: _controller.text);
            },
            child: const Text('Save notes'),
          ),
        ),
      ],
    );
  }
}

class _ItemTile extends ConsumerStatefulWidget {
  const _ItemTile({required this.item});

  final ChecklistItem item;

  @override
  ConsumerState<_ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends ConsumerState<_ItemTile> {
  late final TextEditingController _noteController;
  late final FocusNode _noteFocus;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.item.note);
    _noteFocus = FocusNode();
  }

  @override
  void didUpdateWidget(covariant _ItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_noteFocus.hasFocus && widget.item.note != _noteController.text) {
      _noteController.text = widget.item.note;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.label, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<CheckResult>(
              showSelectedIcon: false,
              emptySelectionAllowed: true,
              segments: const [
                ButtonSegment(value: CheckResult.pass, label: Text('Pass')),
                ButtonSegment(value: CheckResult.fail, label: Text('Fail')),
                ButtonSegment(value: CheckResult.na, label: Text('N/A')),
              ],
              selected: item.result == CheckResult.pending
                  ? <CheckResult>{}
                  : {item.result},
              onSelectionChanged: (selection) {
                if (selection.isEmpty) return;
                ref.read(repositoryProvider).setItemResult(
                      inspectionId: item.inspectionId,
                      itemId: item.id,
                      result: selection.first,
                    );
              },
            ),
            if (item.result == CheckResult.fail) ...[
              const SizedBox(height: 8),
              TextField(
                key: Key('note-${item.id}'),
                controller: _noteController,
                focusNode: _noteFocus,
                decoration: const InputDecoration(labelText: 'Fail note'),
                onSubmitted: (value) {
                  ref.read(repositoryProvider).setItemNote(
                        inspectionId: item.inspectionId,
                        itemId: item.id,
                        note: value,
                      );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

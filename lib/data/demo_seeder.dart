import '../core/clock.dart';
import '../domain/conflict_copy.dart';
import '../domain/inspection.dart';
import '../domain/templates.dart';
import 'remote/inspection_api.dart';
import 'repository/inspection_repository.dart';

/// Plants a few synced visits so the list is not empty on first launch.
class DemoSeeder {
  DemoSeeder({
    required this.repository,
    required this.api,
    required this.clock,
  });

  final InspectionRepository repository;
  final InspectionApi api;
  final Clock clock;

  Future<void> seedIfEmpty() async {
    if (await repository.countActive() > 0) return;
    final now = clock.nowMillis();
    final samples = [
      _visit(
        id: 'seed-panel',
        siteName: 'MCC Panel B',
        assetId: 'MCC-B2',
        template: 'Electrical panel',
        status: InspectionStatus.completed,
        notes: 'Labels match the latest one-line. No heat at the main lugs.',
        updatedAt: now - const Duration(days: 2).inMilliseconds,
        results: CheckResult.pass,
      ),
      _visit(
        id: 'seed-valve',
        siteName: 'Tank Farm Valve Station',
        assetId: 'VLV-88',
        template: 'Valve station',
        status: InspectionStatus.draft,
        notes: '',
        updatedAt: now - const Duration(hours: 3).inMilliseconds,
        results: CheckResult.pending,
      ),
      _visit(
        id: 'seed-pump',
        siteName: 'North Pump House',
        assetId: 'PH-12',
        template: 'Pump house',
        status: InspectionStatus.inProgress,
        notes:
            'Outboard seal is damp. Logging it and leaving the pump in service.',
        updatedAt: now - const Duration(hours: 1).inMilliseconds,
        results: CheckResult.pass,
        failIndex: 1,
      ),
      _visit(
        id: 'seed-generator',
        siteName: 'West Generator Pad',
        assetId: 'GEN-4',
        template: 'Electrical panel',
        status: InspectionStatus.inProgress,
        notes:
            'Sample record: the conflict flag is set so the review state is visible. There is no second device behind it.',
        updatedAt: now - const Duration(minutes: 20).inMilliseconds,
        results: CheckResult.pass,
        failIndex: 0,
        conflict: true,
      ),
    ];
    for (final inspection in samples) {
      await repository.replaceLocal(inspection);
      api.stageServerRecord(remoteFromInspection(inspection));
    }
  }

  Inspection _visit({
    required String id,
    required String siteName,
    required String assetId,
    required String template,
    required InspectionStatus status,
    required String notes,
    required int updatedAt,
    required CheckResult results,
    int? failIndex,
    bool conflict = false,
  }) {
    final labels = checklistTemplates[template];
    if (labels == null) {
      throw StateError('Missing template $template');
    }
    return Inspection(
      id: id,
      siteName: siteName,
      assetId: assetId,
      inspector: 'Arpan Bom',
      status: status,
      notes: notes,
      updatedAt: updatedAt,
      baseUpdatedAt: updatedAt,
      conflictFlag: conflict,
      conflictDetail: conflict ? serverWonConflictDetail : '',
      pendingSync: false,
      deleted: false,
      syncError: null,
      items: [
        for (var index = 0; index < labels.length; index++)
          ChecklistItem(
            id: '$id-$index',
            inspectionId: id,
            label: labels[index],
            result: failIndex == index ? CheckResult.fail : results,
            note: failIndex == index
                ? 'Needs a follow-up on the next visit.'
                : '',
            position: index,
          ),
      ],
    );
  }
}

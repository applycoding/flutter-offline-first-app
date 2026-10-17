import 'package:flutter/material.dart';
import 'package:flutter_offline_first_app/domain/conflict_copy.dart';
import 'package:flutter_offline_first_app/domain/inspection.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('marking pass moves the visit to in progress', (tester) async {
    final env = await TestEnv.open();
    try {
      final created = await env.createPump();
      await pumpApp(tester, env);
      await tester.tap(find.text('North Pump House'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Pass').first);
      await tester.pumpAndSettle();

      expect(find.text('In progress'), findsWidgets);
      final stored = await env.repository.getById(created.id);
      expect(stored!.items.first.result, CheckResult.pass);
      expect(stored.status, InspectionStatus.inProgress);
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('conflict banner can be dismissed', (tester) async {
    final env = await TestEnv.open();
    try {
      final created = await env.createPump();
      await env.queue.markDone((await env.queue.pending()).single.id);
      await env.repository.replaceLocal(
        (await env.repository.getById(created.id))!.copyWith(
          conflictFlag: true,
          conflictDetail: serverWonConflictDetail,
          pendingSync: false,
          baseUpdatedAt: created.updatedAt,
        ),
      );

      await pumpApp(tester, env);
      expect(find.text('Conflict'), findsOneWidget);
      await tester.tap(find.text('North Pump House'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('conflict-banner')), findsOneWidget);
      expect(find.text(serverWonConflictDetail), findsOneWidget);

      await tester.tap(find.byKey(const Key('dismiss-conflict')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('conflict-banner')), findsNothing);
      expect(
        (await env.repository.getById(created.id))!.conflictFlag,
        isFalse,
      );
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('delete asks for confirmation and leaves the list',
      (tester) async {
    final env = await TestEnv.open();
    try {
      await env.createPump();
      await pumpApp(tester, env);
      await tester.tap(find.text('North Pump House'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('delete-inspection')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('confirm-delete')));
      await tester.pumpAndSettle();

      expect(find.text('North Pump House'), findsNothing);
      expect(
          find.text(
              'No inspections yet. Add a site visit to start a checklist.'),
          findsOneWidget);
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('detail lays out on a narrow screen', (tester) async {
    final env = await TestEnv.open();
    try {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await env.createPump();
      await pumpApp(tester, env);
      await tester.tap(find.text('North Pump House'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
          find.text('Housekeeping and access clear'), 200);
      expect(find.text('Housekeeping and access clear'), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      await shutdown(tester, env);
    }
  });
}

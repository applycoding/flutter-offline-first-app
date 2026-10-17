import 'package:flutter/material.dart';
import 'package:flutter_offline_first_app/providers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';

void main() {
  testWidgets('empty list explains how to start', (tester) async {
    final env = await TestEnv.open();
    try {
      await pumpApp(tester, env);
      expect(
        find.text('No inspections yet. Add a site visit to start a checklist.'),
        findsOneWidget,
      );
      expect(
          find.text('Online. Queued edits push to the in-memory field server.'),
          findsOneWidget);
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('shows a saved inspection and opens it', (tester) async {
    final env = await TestEnv.open();
    try {
      await env.createPump();
      await pumpApp(tester, env);
      expect(find.text('North Pump House'), findsOneWidget);
      expect(find.text('0 of 5 checked'), findsOneWidget);
      expect(find.text('Draft'), findsOneWidget);

      await tester.tap(find.text('North Pump House'));
      await tester.pumpAndSettle();
      expect(find.text('Lockout and tagout confirmed'), findsOneWidget);
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('offline toggle keeps a new inspection in the queue',
      (tester) async {
    final env = await TestEnv.open();
    try {
      await pumpApp(tester, env);
      await tester.tap(find.byKey(const Key('connectivity-toggle')));
      await tester.pumpAndSettle();
      expect(
        find.text('Offline. Edits stay in the sync queue on this device.'),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('new-inspection')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('field-site')), 'East Clarifier');
      await tester.enterText(find.byKey(const Key('field-asset')), 'CL-3');
      await tester.tap(find.byKey(const Key('create-inspection')));
      await tester.pumpAndSettle();

      expect(find.text('East Clarifier'), findsOneWidget);
      expect(find.byKey(const Key('pending-badge')), findsOneWidget);
      expect(env.api.requests, isEmpty);

      await tester.tap(find.byKey(const Key('connectivity-toggle')));
      await tester.pumpAndSettle();

      expect(env.api.requests.single.method, 'PUT');
      expect(await env.queue.pending(), isEmpty);
      expect(find.byKey(const Key('pending-badge')), findsNothing);
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('create form requires a site name', (tester) async {
    final env = await TestEnv.open();
    try {
      await pumpApp(tester, env);
      await tester.tap(find.byKey(const Key('new-inspection')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('field-site')), '   ');
      await tester.tap(find.byKey(const Key('create-inspection')));
      await tester.pumpAndSettle();
      expect(find.text('Enter a site name.'), findsOneWidget);
      expect(await env.repository.countActive(), 0);
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('sync button reports an empty queue', (tester) async {
    final env = await TestEnv.open();
    try {
      await pumpApp(tester, env);
      await tester.tap(find.byKey(const Key('sync-button')));
      await tester.pump();
      expect(find.text('Nothing to push.'), findsOneWidget);
      await tester.pumpAndSettle();
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('bootstrap failure shows an error state', (tester) async {
    final env = await TestEnv.open();
    try {
      await tester.pumpWidget(
        env.buildApp(
          extraOverrides: [
            bootstrapProvider.overrideWith((ref) async {
              throw StateError('database unavailable');
            }),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Could not open local inspections'), findsOneWidget);
      expect(find.textContaining('database unavailable'), findsOneWidget);
    } finally {
      await shutdown(tester, env);
    }
  });

  testWidgets('seeded list lays out on a narrow screen', (tester) async {
    final env = await TestEnv.open();
    try {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(env.buildApp(seed: true));
      await tester.pumpAndSettle();

      expect(find.text('West Generator Pad'), findsOneWidget);
      expect(find.text('Conflict'), findsWidgets);
      await tester.tap(find.text('West Generator Pad'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('conflict-banner')), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      await shutdown(tester, env);
    }
  });
}

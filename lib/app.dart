import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'ui/inspection_list_screen.dart';
import 'ui/theme.dart';

class SiteCheckApp extends StatelessWidget {
  const SiteCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiteCheck',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const ConnectivityHost(child: BootstrapScreen()),
    );
  }
}

class ConnectivityHost extends ConsumerStatefulWidget {
  const ConnectivityHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConnectivityHost> createState() => _ConnectivityHostState();
}

class _ConnectivityHostState extends ConsumerState<ConnectivityHost> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!ref.read(pollConnectivityProvider)) return;
      unawaited(ref.read(onlineProvider.notifier).refresh());
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        unawaited(ref.read(onlineProvider.notifier).refresh());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class BootstrapScreen extends ConsumerWidget {
  const BootstrapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(bootstrapProvider);
    return bootstrap.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(key: Key('bootstrap-loading')),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Could not open local inspections',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('$error', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(bootstrapProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (_) => const InspectionListScreen(),
    );
  }
}

import 'package:flutter/material.dart';

import '../domain/inspection.dart';
import 'labels.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final InspectionStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color background;
    final Color foreground;
    switch (status) {
      case InspectionStatus.draft:
        background = scheme.surfaceContainerHighest;
        foreground = scheme.onSurface;
      case InspectionStatus.inProgress:
        background = scheme.tertiaryContainer;
        foreground = scheme.onTertiaryContainer;
      case InspectionStatus.completed:
        background = scheme.primaryContainer;
        foreground = scheme.onPrimaryContainer;
    }
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: background,
      side: BorderSide.none,
      label: Text(
        inspectionStatusLabel(status),
        style: TextStyle(color: foreground),
      ),
    );
  }
}

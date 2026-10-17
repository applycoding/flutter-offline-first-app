import '../domain/inspection.dart';

String inspectionStatusLabel(InspectionStatus status) {
  switch (status) {
    case InspectionStatus.draft:
      return 'Draft';
    case InspectionStatus.inProgress:
      return 'In progress';
    case InspectionStatus.completed:
      return 'Complete';
  }
}

String formatStamp(int millis) {
  final local = DateTime.fromMillisecondsSinceEpoch(
    millis,
    isUtc: true,
  ).toLocal();
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.year}-$month-$day $hour:$minute';
}

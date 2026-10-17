/// Shown when this device's later timestamp overwrote the server record.
const String localWonConflictDetail =
    "Conflict: this device's later edit overwrote the server (last write wins).";

/// Shown when a newer server timestamp replaced this device's edits.
const String serverWonConflictDetail =
    "Conflict: a newer server edit replaced this device's changes (last write wins).";

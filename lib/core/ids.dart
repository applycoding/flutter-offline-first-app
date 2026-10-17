import 'package:uuid/uuid.dart';

abstract class IdGenerator {
  String newId();
}

class UuidGenerator implements IdGenerator {
  UuidGenerator() : _uuid = const Uuid();

  final Uuid _uuid;

  @override
  String newId() => _uuid.v4();
}

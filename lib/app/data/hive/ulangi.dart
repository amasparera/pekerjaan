import 'package:hive_flutter/hive_flutter.dart';

part 'ulangi.g.dart';

@HiveType(typeId: 1)
class Ulangi {
  @HiveField(0)
  final List<DateTime> ulangan;
  @HiveField(1)
  DateTime update;
  @HiveField(2)
  final Map model;
  @HiveField(3)
  final String idcategory;

  Ulangi(this.ulangan, this.update, this.model, this.idcategory);
}

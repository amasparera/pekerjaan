import 'package:cloud_firestore/cloud_firestore.dart';

class PekerjaanModel {
  String? id;
  String? name;
  String? descripsi;
  String? namePekerja;
  DateTime? hariIni;
  // DateTime? update;
  bool? status;

  // List? day = [];
  PekerjaanModel(
      {required this.id,
      required this.name,
      required this.status,
      required this.namePekerja});

  PekerjaanModel.fromJson(
    json,
  ) {
    namePekerja = json['namapekerja'];
    status = json['status'];
    name = json['name'];
    // day = json['day'];
    id = json['id'];
    descripsi = json['descripsi'];
    hariIni = (json['hariini'] as Timestamp).toDate();
    // update = (json['update'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

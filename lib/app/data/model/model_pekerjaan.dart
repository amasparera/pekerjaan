import 'package:cloud_firestore/cloud_firestore.dart';

class PekerjaanModel {
  String? id;
  String? name;
  String? descripsi;
  String? namePekerja;
  String? image;
  DateTime? hariIni;
  bool? barcode;
  DateTime? wktumengerjakkan;
  bool? status;

  List? day = [];
  PekerjaanModel(
      {required this.id,
      required this.name,
      required this.status,
      required this.namePekerja,
      required this.descripsi,
      required this.hariIni});

  PekerjaanModel.fromJson(
    json,
  ) {
    namePekerja = json['namapekerja'];
    status = json['status'];
    name = json['name'];
    day = json['day'];
    id = json['id'];
    descripsi = json['descripsi'];
    hariIni = (json['hariini'] as Timestamp).toDate();
    barcode = json['barcode'];
    image = json['image'];
    wktumengerjakkan = json['waktuMengerjakan'] != null
        ? (json['waktuMengerjakan'] as Timestamp).toDate()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

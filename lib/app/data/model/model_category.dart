import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? name;
  String? idPekerjaan;
  List? idUser;
  List? namauser;
  String? admin;
  int? totalTugas;
  DateTime? dibuat;

  CategoryModel(
      {required this.name,
      required this.idUser,
      required this.idPekerjaan,
      required this.namauser});

  CategoryModel.fromJson(json) {
    name = json['name'];
    idUser = json['idUser'];
    idPekerjaan = json['id'];
    namauser = json['listnama'];
    admin = json['admin'];
    totalTugas = json['total_tugas'] ?? 0;
    dibuat = (json['dibuat'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['idUser'] = idUser;
    return data;
  }
}

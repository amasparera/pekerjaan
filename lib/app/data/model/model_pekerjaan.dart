class PekerjaanModel {
  String? id;
  String? name;
  String? namePekerja;
  bool? status;
  List? day = [];
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
    day = json['day'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

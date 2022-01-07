class PekerjaanModel {
  String? categoty;
  String? name;
  bool? status;
  List? day = [];
  PekerjaanModel(
      {required this.categoty,
      required this.name,
      required this.status,
      required});

  PekerjaanModel.fromJson(
    json,
  ) {
    status = json['dikerjakan'];
    name = json['name'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

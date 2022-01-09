class CategoryModel {
  String? name;
  String? idPekerjaan;
  List? idUser;
  List? namauser;

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['idUser'] = idUser;
    return data;
  }
}

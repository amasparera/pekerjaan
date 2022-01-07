class CategoryModel {
  String? name;
  String? idPekerjaan;
  List? idUser;

  CategoryModel({required this.name, required this.idUser});

  CategoryModel.fromJson(json) {
    name = json['name'];
    idUser = json['idUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['idUser'] = idUser;
    return data;
  }
}

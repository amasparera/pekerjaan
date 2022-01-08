class UserModel {
  String? id;
  String? name;
  String? email;
  String? profileUrl;
  String? username;

  UserModel({this.id, this.name});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['userid'];
    name = json['name'];
    email = json['email'];
    profileUrl = json['profileUrl'];
    username = json['username'];
  }
}

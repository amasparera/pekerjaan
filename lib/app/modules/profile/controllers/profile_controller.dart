import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/auth_google.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/data/model/myuser.dart';

class ProfileController extends GetxController {
  TextEditingController input = TextEditingController();
  UserModel myUser = UserModel();
  var masukaninput = ''.obs;

  iniUser() {
    Myuser ini = Myuser();
    myUser.email = ini.loadEmail();
    myUser.id = ini.loadUserId();
    myUser.name = ini.loadDisplayName();
    myUser.username = ini.loadUserName();
  }

  gabung() async {
    if (input.text != '') {
      CategoryModel? model = await FirebaseFirestroreku().gabung(input.text);
      if (model != null) {
        List nama = model.namauser!;
        nama.add(myUser.name);
        List listid = model.idUser!;
        listid.add(myUser.id);

        FirebaseFirestroreku().tambahAnggota(input.text, listid, nama);
      }
    } else {
      masukaninput.value = 'masukan id';
    }
  }

  void logOut() {
    AuthUser().signOut();
  }

  @override
  void onInit() async {
    await iniUser();
    super.onInit();
  }
}

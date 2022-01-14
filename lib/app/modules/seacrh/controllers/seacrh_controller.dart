import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/data/model/myuser.dart';

class SeacrhController extends GetxController {
  var seacrh = TextEditingController();

  var listdata = <UserModel>[].obs;
  late String saya;
  CategoryModel argumen = Get.arguments;

  Future<List<UserModel>> searchUser() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: seacrh.text)
        .get();
    List<UserModel> map =
        data.docs.map((e) => UserModel.fromJson(e.data())).toList();

    var oke = map
        .where((element) =>
            element.name!.contains(seacrh.text) && element.id != saya)
        .toList();

    return listdata.value = oke;
  }

  void tambahAnggota(UserModel model) async {
    if (!argumen.idUser!.contains(model.id)) {
      List nama = argumen.namauser!;

      nama.add(model.name);

      List listid = argumen.idUser!;
      listid.add(model.id);
      FirebaseFirestroreku().tambahAnggota(argumen.idPekerjaan, listid, nama);
      Get.back();
      Get.back();
      Get.snackbar('Berhasil', 'Berhasil menambahakan ${model.name}');
    } else {
      Get.back();
      Get.back();
      Get.snackbar('Gagal', 'User sudah menjadi Anggota');
    }
  }

  @override
  void onInit() {
    super.onInit();
    saya = Myuser().loadUserId();
  }
}

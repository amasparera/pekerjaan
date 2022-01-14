import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/hive/hive_update.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController text = TextEditingController();

  late String userIdSaya;
  late String myName;
  late String profileurl;
  int total = 0;

  void toPekerjaan(id) {
    Get.toNamed(Routes.PEKERJAAN, arguments: id);
  }

  void addPekerjaan() async {
    if (text.text != '') {
      FirebaseFirestroreku().pekerjaanAdd(text.text, userIdSaya, myName);
      text.clear();
      Get.back();
    }
  }

  void batal() {
    Get.back();
    text.clear();
  }

  void hapus(id) {
    FirebaseFirestroreku().hapus(id);
    Update().bersihkan(id);
  }

  //

  void init() async {
    userIdSaya = Myuser().loadUserId();
    myName = Myuser().loadDisplayName();
    profileurl = Myuser().loadPRofilePic();
    Update().cekUlangi();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}

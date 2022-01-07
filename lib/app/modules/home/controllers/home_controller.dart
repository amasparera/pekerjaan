import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController text = TextEditingController();
  String saya = Myuser.demo;

  void toPekerjaan(int index) {
    Get.toNamed(Routes.PEKERJAAN);
  }

  void addPekerjaan() {
    if (text.text != '') {
      FirebaseFirestroreku().pekerjaanAdd(text.text, saya);
      text.clear();
      Get.back();
    }
  }

  void hapus(id) {
    FirebaseFirestroreku().hapus(id);
  }
}

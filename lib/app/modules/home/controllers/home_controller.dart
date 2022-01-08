import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController text = TextEditingController();

  late String userIdSaya;

  void toPekerjaan(int index) {
    Get.toNamed(Routes.PEKERJAAN);
  }

  void addPekerjaan() async {
    if (text.text != '') {
      String userIdSaya = Myuser().loadEmail();
      FirebaseFirestroreku().pekerjaanAdd(text.text, userIdSaya);
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
  }

  void init() async {
    userIdSaya = Myuser().loadEmail();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}

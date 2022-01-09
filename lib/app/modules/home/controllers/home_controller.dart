import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/data/model/myuser.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController text = TextEditingController();

  late String userIdSaya;
  late String myName;

  void tambahAnggota(CategoryModel model) async {
    try {
      await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", false, ScanMode.QR)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(value)
            .get()
            .then((value) {
          if (value.exists) {
            UserModel userModel = UserModel.fromJson(value.data()!);
            List nama = model.namauser!;
            nama.add(userModel.name);

            List listid = model.idUser!;
            listid.add(value);
            return FirebaseFirestroreku()
                .tambahAnggota(model.idPekerjaan, nama, listid);
          }
        });
      });
      // ignore: empty_catches
    } on PlatformException {}
  }

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
  }

  void init() async {
    userIdSaya = Myuser().loadUserId();
    myName = Myuser().loadUserName();
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }
}

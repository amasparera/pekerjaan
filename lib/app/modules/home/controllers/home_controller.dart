import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/hive/hive_update.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

class HomeController extends GetxController {
  TextEditingController text = TextEditingController();

  late String userIdSaya;
  late String myName;
  late String profileurl;
  int total = 0;

  List<String> icon = [
    'assest/iconcart/Be Careful On The Road.png',
    'assest/iconcart/Blood Donors.png',
    'assest/iconcart/Charity.png',
    'assest/iconcart/Food Donation.png',
    'assest/iconcart/Food Donation.png',
    'assest/iconcart/Free Food.png',
    'assest/iconcart/Heart Hand.png',
    'assest/iconcart/Let Live Healthy.png',
    'assest/iconcart/let Vaccinate.png',
    'assest/iconcart/Love Reading.png',
    'assest/iconcart/Open Donation.png',
    'assest/iconcart/Qurban.png',
    'assest/iconcart/Rice Donation.png',
    'assest/iconcart/Save Energy.png',
    'assest/iconcart/Stop Illegal Fees.png',
    'assest/iconcart/Stop Smoking.png',
    'assest/iconcart/Take Care Of Pregnant Women.png',
    'assest/iconcart/Throw Garbage In Its Place.png',
    'assest/iconcart/Toys Donation.png',
    'assest/iconcart/Volunteering.png',
    'assest/iconcart/Wear a Mask.png'
  ];

  String setIcon = 'assest/iconcart/Be Careful On The Road.png';

  // List<DropdownMenuItem> items (List<String> item){

  // }

  void toPekerjaan(CategoryModel pekerjaanModel) {
    Get.toNamed(Routes.PEKERJAAN, arguments: pekerjaanModel);
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

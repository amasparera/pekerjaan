import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';

class PekerjaanController extends GetxController {
  TextEditingController input = TextEditingController();

  var argumen = Get.arguments;

  void menambahkanPekerjan() async {
    await FirebaseFirestroreku().documentTugas(argumen).then((value) {
      Map<String, dynamic> map = {
        'id': value.id,
        'name': input.text,
        'status': false,
        'namapekerja': ''
      };

      return FirebaseFirestroreku()
          .menambahTugas(data: map, id: argumen, idtugas: value.id);
    });
  }

  void mengerjakan(idtugas) async {
    String namapekerja = Myuser().loadDisplayName();
    FirebaseFirestroreku()
        .mengerjakan(id: argumen, idtugas: idtugas, namapekerja: namapekerja);
  }
}

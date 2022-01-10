import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';

class PekerjaanController extends GetxController {
  TextEditingController input = TextEditingController();
  var opsiTgl = 1.obs;

  var argumen = Get.arguments;

  DateTime waktuSekarang = DateTime.now();

  void menambahkanPekerjan() async {
    if (input.text != '') {
      await FirebaseFirestroreku().documentTugas(argumen).then((value) {
        Map<String, dynamic> map = {};

        if (opsiTgl.value == 1) {
          map = {
            'id': value.id,
            'name': input.text,
            'status': false,
            'namapekerja': '',
            'hariini': waktuSekarang
          };
        } else if (opsiTgl.value == 2) {}

        return FirebaseFirestroreku()
            .menambahTugas(data: map, id: argumen, idtugas: value.id);
      });
      input.clear();
    }
  }

  void mengerjakan(idtugas) async {
    String namapekerja = Myuser().loadDisplayName();
    FirebaseFirestroreku()
        .mengerjakan(id: argumen, idtugas: idtugas, namapekerja: namapekerja);
  }

  void belumDikerjakan(idtugas) {
    FirebaseFirestroreku().belumDikerjaan(id: argumen, idtugas: idtugas);
  }

  void hapusTugas(idtugas) {
    FirebaseFirestroreku().hapusTugas(id: argumen, idtugas: idtugas);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/hive/hive_update.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';

class PekerjaanController extends GetxController {
  TextEditingController input = TextEditingController();
  var opsiTgl = false.obs;

  CategoryModel argumen = Get.arguments;
  var hariini = 'Tgl Hari Ini'.obs;
  var descripsi = 'no scan'.obs;

  var waktuDipilih = DateTime.now().obs;
  var range = DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  var open = false.obs;

  void menambahkanPekerjan() async {
    if (opsiTgl.value == false) {
      await FirebaseFirestroreku()
          .documentTugas(argumen.idPekerjaan!)
          .then((value) {
        Map<String, dynamic> map = {
          'id': value.id,
          'name': input.text,
          'status': false,
          'namapekerja': '',
          'descripsi': descripsi.value,
          'hariini': waktuDipilih.value
        };
        FirebaseFirestroreku()
            .jumlahTugas(argumen.idPekerjaan, argumen.totalTugas! + 1);
        FirebaseFirestroreku().menambahTugas(
            data: map, id: argumen.idPekerjaan, idtugas: value.id);
      });
      input.clear();
    } else {
      // await FirebaseFirestroreku()
      //     .documentTugas(argumen.idPekerjaan)
      //     .then((value) {
      //   Map<String, dynamic> map = {
      //     'id': value.id,
      //     'name': input.text,
      //     'status': false,
      //     'namapekerja': '',
      //     'descripsi': descripsi.value,
      //     'hariini': waktuDipilih.value,
      //     // 'day': ulangi,
      //   };

      //   // Update().menambahUlangi(
      //   //   argumen.idPekerjaan!,
      //   //   map,
      //   // day,
      //   // );

      //   opsiTgl.value = false;
      //   FirebaseFirestroreku()
      //       .jumlahTugas(argumen.idPekerjaan, argumen.totalTugas! + 1);
      //   FirebaseFirestroreku().menambahTugas(
      //       data: map, id: argumen.idPekerjaan, idtugas: value.id);
      // });
    }
  }

  void orderTime(context) async {
    DateTime? order = await showDatePicker(
        context: context,
        initialDate: waktuDipilih.value,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (order != null) {
      waktuDipilih.value = order;
    }
  }

  void rangeWaktu(context) async {
    DateTimeRange? data = await showDateRangePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2030));

    if (data == null) {
    } else {
      range.value = data;
    }
  }

  void mengerjakan(idtugas) async {
    String namapekerja = Myuser().loadDisplayName();
    FirebaseFirestroreku().mengerjakan(
        id: argumen.idPekerjaan, idtugas: idtugas, namapekerja: namapekerja);
  }

  void belumDikerjakan(idtugas) {
    FirebaseFirestroreku()
        .belumDikerjaan(id: argumen.idPekerjaan, idtugas: idtugas);
  }

  void hapusTugas(idtugas) {
    FirebaseFirestroreku()
        .jumlahTugas(argumen.idPekerjaan, argumen.totalTugas! - 1);
    FirebaseFirestroreku()
        .hapusTugas(id: argumen.idPekerjaan, idtugas: idtugas);
  }
}

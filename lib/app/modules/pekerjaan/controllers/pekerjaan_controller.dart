import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';

class PekerjaanController extends GetxController {
  TextEditingController input = TextEditingController();
  var opsiTgl = 1.obs;

  var argumen = Get.arguments;
  var hariini = 'Tgl Hari Ini'.obs;
  var descripsi = 'Tgl:'.obs;

  var waktuSekarang = DateTime.now().obs;

  var open = false.obs;

  var senin = false.obs;
  var selasa = false.obs;
  var rabu = false.obs;
  var kamis = false.obs;
  var jumat = false.obs;
  var sabtu = false.obs;
  var minggu = false.obs;

  void menambahkanPekerjan() async {
    if (opsiTgl.value != 3) {
      await FirebaseFirestroreku().documentTugas(argumen).then((value) {
        Map<String, dynamic> map = {
          'id': value.id,
          'name': input.text,
          'status': false,
          'namapekerja': '',
          'descripsi': descripsi.value,
          'hariini': waktuSekarang.value
        };
        return FirebaseFirestroreku()
            .menambahTugas(data: map, id: argumen, idtugas: value.id);
      });
      input.clear();
    } else if (senin.isTrue ||
        selasa.isTrue ||
        rabu.isTrue ||
        kamis.isTrue ||
        jumat.isTrue ||
        sabtu.isTrue ||
        minggu.isTrue) {
      await FirebaseFirestroreku().documentTugas(argumen).then((value) {
        List<DateTime> day = [];

        if (senin.isTrue) {
          day.add(DateTime.utc(99));
        }
        // if (selasa.isTrue) {
        //   day.add(DateTime.tuesday);
        // }
        // if (rabu.isTrue) {
        //   day.add(DateTime.wednesday);
        // }
        // if (kamis.isTrue) {
        //   day.add(DateTime.thursday);
        // }
        // if (jumat.isTrue) {
        //   day.add(DateTime.friday);
        // }
        // if (sabtu.isTrue) {
        //   day.add(DateTime.saturday);
        // }
        // if (minggu.isTrue) {
        //   day.add(DateTime.sunday);
        // }
        Map<String, dynamic> map = {
          'id': value.id,
          'name': input.text,
          'status': false,
          'namapekerja': '',
          'descripsi': descripsi.value,
          'update': waktuSekarang.value,
          'day': day
        };

        return FirebaseFirestroreku()
            .menambahTugasulang(data: map, id: argumen, idtugas: value.id);
      });
      input.clear();
    } else {}
  }

  void orderTime(context) async {
    DateTime? order = await showDatePicker(
        context: context,
        initialDate: waktuSekarang.value,
        firstDate: DateTime(2021),
        lastDate: DateTime(2030));
    if (order != null) {
      waktuSekarang.value = order;
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

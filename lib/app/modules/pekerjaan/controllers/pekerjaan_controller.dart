import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';

class PekerjaanController extends GetxController {
  TextEditingController input = TextEditingController();
  var opsiTgl = 1.obs;

  var argumen = Get.arguments;
  var hariini = 'Tgl Hari Ini'.obs;
  var descripsi = 'sekali hari ini'.obs;

  var waktuSekarang = DateTime.now().obs;

  var senin = false.obs;
  var selasa = false.obs;
  var rabu = false.obs;
  var kamis = false.obs;
  var jumat = false.obs;
  var sabtu = false.obs;
  var minggu = false.obs;

  void menambahkanPekerjan() async {
    if (input.text != '' && opsiTgl.value != 3) {
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
    } else {
      await FirebaseFirestroreku().documentTugas(argumen).then((value) {
        List day = [];

        if (senin.isTrue) {
          day.add(DateTime.monday);
        }
        if (selasa.isTrue) {
          day.add(DateTime.tuesday);
        }
        if (rabu.isTrue) {
          day.add(DateTime.wednesday);
        }
        if (kamis.isTrue) {
          day.add(DateTime.thursday);
        }
        if (jumat.isTrue) {
          day.add(DateTime.friday);
        }
        if (sabtu.isTrue) {
          day.add(DateTime.saturday);
        }
        if (minggu.isTrue) {
          day.add(DateTime.sunday);
        }
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
            .menambahTugas(data: map, id: argumen, idtugas: value.id);
      });
      input.clear();
    }
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

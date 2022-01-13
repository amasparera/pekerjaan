import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/hive/hive_update.dart';

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
        List ulangi = [];

        if (senin.isTrue) {
          day.add(DateTime.utc(2022, 1, 10));
          ulangi.add('senin');
        }
        if (selasa.isTrue) {
          day.add(DateTime.utc(2022, 1, 11));
          ulangi.add('selasa');
        }
        if (rabu.isTrue) {
          day.add(DateTime.utc(2022, 1, 12));
          ulangi.add('rabu');
        }
        if (kamis.isTrue) {
          day.add(DateTime.utc(2022, 1, 13));
          ulangi.add('kamis');
        }
        if (jumat.isTrue) {
          day.add(DateTime.utc(2022, 1, 14));
          ulangi.add('jum\'at');
        }
        if (sabtu.isTrue) {
          day.add(DateTime.utc(2022, 1, 15));
          ulangi.add('sabtu');
        }
        if (minggu.isTrue) {
          day.add(DateTime.utc(2022, 1, 16));
          ulangi.add('minggu');
        }
        Map<String, dynamic> map = {
          'id': value.id,
          'name': input.text,
          'status': false,
          'namapekerja': '',
          'descripsi': descripsi.value,
          'hariini': waktuSekarang.value,
          'day': ulangi,
        };

        Update().menambahUlangi(
          argumen,
          map,
          day,
        );
        senin.value = false;
        selasa.value = false;
        rabu.value = false;
        kamis.value = false;
        jumat.value = false;
        sabtu.value = false;
        minggu.value = false;

        opsiTgl.value = 1;

        FirebaseFirestroreku()
            .menambahTugas(data: map, id: argumen, idtugas: value.id);
        ulangi.clear();
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

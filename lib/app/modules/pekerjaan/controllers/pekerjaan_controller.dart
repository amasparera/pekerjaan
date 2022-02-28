import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/data/model/model_pekerjaan.dart';

class PekerjaanController extends GetxController {
  TextEditingController input = TextEditingController();
  var opsiTgl = false.obs;
  var barcode = false.obs;

  CategoryModel argumen = Get.arguments;
  var hariini = 'Tgl Hari Ini'.obs;
  var descripsi = 'no scan'.obs;

  var waktuDipilih = DateTime.now().obs;
  // var range = DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;

  var open = false.obs;

  void menambahkanPekerjan() async {
    // if (opsiTgl.isFalse) {
    if (input.text != '') {
      await FirebaseFirestroreku()
          .documentTugas(argumen.idPekerjaan!)
          .then((value) {
        Map<String, dynamic> map = {
          'id': value.id,
          'name': input.text,
          'status': false,
          'barcode': barcode.value,
          'namapekerja': '',
          'descripsi': descripsi.value,
          'hariini': waktuDipilih.value
        };
        FirebaseFirestroreku().tambahJumlah(argumen.idPekerjaan);
        FirebaseFirestroreku().menambahTugas(
            data: map, id: argumen.idPekerjaan, idtugas: value.id);
      });
      input.clear();
    }
    // } else {
    // await FirebaseFirestroreku()
    //     .documentTugas(argumen.idPekerjaan!)
    //     .then((value) {
    //   Map<String, dynamic> map = {
    //     'id': value.id,
    //     'name': input.text,
    //     'status': false,
    //     'barcode': barcode.value,
    //     'namapekerja': '',
    //     'descripsi': descripsi.value,
    //     'hariini': waktuDipilih.value
    //   };
    //   FirebaseFirestroreku().tambahJumlah(argumen.idPekerjaan);
    //   FirebaseFirestroreku().menambahTugas(
    //       data: map, id: argumen.idPekerjaan, idtugas: value.id);
    // });
    // }
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

  void rangeWaktu(context, PekerjaanModel model) async {
    await showDateRangePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2030))
        .then((value) async {
      if (value == null) {
        Get.back();
        Get.snackbar('Gagal', 'gagal mengulang tanggal kosong',
            colorText: Colors.white);
      } else {
        var start = value.start;
        var end = value.end;
        List<DateTime> list = [];
        while (start.isBefore(end.add(const Duration(days: 1)))) {
          list.add(start);
          start = start.add(const Duration(days: 1));
        }
        lopingwaktu(model, list);
      }
    });
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
    FirebaseFirestroreku().kurangiJumlah(argumen.idPekerjaan);
    FirebaseFirestroreku()
        .hapusTugas(id: argumen.idPekerjaan, idtugas: idtugas);
  }

  lopingwaktu(PekerjaanModel model, List<DateTime> list) async {
    for (var index = 0; index <= list.length - 1; index++) {
      await FirebaseFirestroreku()
          .documentTugas(argumen.idPekerjaan!)
          .then((value) {
        Map<String, dynamic> map = {
          'id': value.id,
          'name': model.name,
          'status': false,
          'barcode': model.barcode,
          'namapekerja': '',
          'descripsi': model.descripsi,
          'hariini': list[index]
        };
        FirebaseFirestroreku().tambahJumlah(argumen.idPekerjaan);
        FirebaseFirestroreku().menambahTugas(
            data: map, id: argumen.idPekerjaan, idtugas: value.id);
      });
    }
    Get.back();
  }

  //ulangi
  List<String> day = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jum\'at',
    'Sabtu',
    'Minggu'
  ];

  List<int> indexUlangi = [];

  void ontap(int index) {
    if (indexUlangi.contains(index)) {
      indexUlangi.remove(index);
      update();
    } else {
      indexUlangi.add(index);
      update();
    }
  }
}

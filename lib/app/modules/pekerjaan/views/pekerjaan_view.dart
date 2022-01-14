import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pekerjaan/app/data/model/model_pekerjaan.dart';

import '../controllers/pekerjaan_controller.dart';

class PekerjaanView extends GetView<PekerjaanController> {
  const PekerjaanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          title: const Text('Semua Pekerjaan'),
        ),
      ),
      body: Stack(
        children: [
          body(),
          menambahPekerjaan(context),
        ],
      ),
    );
  }

  Widget body() {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(controller.argumen)
        .collection('tugas')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR'),
            );
          } else {
            List<PekerjaanModel> pekerjaan = snapshot.data!.docs
                .map((e) => PekerjaanModel.fromJson(e.data()))
                .toList();
            pekerjaan.sort((a, b) => a.hariIni!.compareTo(b.hariIni!));
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: pekerjaan.length,
              itemBuilder: (context, index) =>
                  hariIni(context, pekerjaan, index),
            );
          }
        });
  }

  ListTile hariIni(
      BuildContext context, List<PekerjaanModel> pekerjaan, int index) {
    return ListTile(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) =>
                dialogEdit(pekerjaan[index].id, context, pekerjaan[index].day));
      },
      onTap: () {
        if (pekerjaan[index].status == false) {
          controller.mengerjakan(pekerjaan[index].id);
        }
      },
      leading: pekerjaan[index].status == false
          ? const Icon(Icons.circle_outlined)
          : const Icon(Icons.run_circle_rounded, color: Colors.blue),
      title: pekerjaan[index].status == false
          ? Text(pekerjaan[index].name!)
          : Text(pekerjaan[index].name!,
              style: const TextStyle(
                  color: Colors.grey, decoration: TextDecoration.lineThrough)),
      subtitle: Text(
        DateFormat.MMMd().format(pekerjaan[index].hariIni!),
        style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
      trailing: Text(pekerjaan[index].namePekerja!,
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
    );
  }

//  ${DateFormat.E().format(DateTime.now())}
  Dialog dialogEdit(idtugas, context, listday) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: 200,
          child: Column(
            children: [
              const Text(
                'Pilihan Mengedit',
                style: TextStyle(fontSize: 18),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 10),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          controller.belumDikerjakan(idtugas);
                          Get.back();
                        },
                        child: const Center(
                          child: Text(
                            'Belum Dikerjakan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.red,
                      child: InkWell(
                        onTap: () {
                          controller.hapusTugas(idtugas);
                          Get.back();
                        },
                        child: const Center(
                          child: Text(
                            'Hapus Tugas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  Widget menambahPekerjaan(context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Obx(
            () => controller.open.value == false
                ? const SizedBox()
                : requesTanggal(context),
          ),
          Container(
            height: 75,
            alignment: Alignment.bottomCenter,
            color: Colors.blue[200],
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      controller.open.value = !controller.open.value;
                    },
                    icon: const Icon(Icons.more_vert_rounded)),
                Expanded(
                  child: TextField(
                    autofocus: false,
                    onChanged: (val) {
                      // ignore: avoid_print
                      print(val);
                    },
                    controller: controller.input,
                    decoration: InputDecoration(
                        suffix: GestureDetector(
                            onTap: () {
                              if (controller.input.text != '') {
                                controller.menambahkanPekerjan();
                              }
                            },
                            child: const Icon(Icons.send)),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Tambah tugas'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget requesTanggal(context) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: Obx(() => InkWell(
                  onTap: () {
                    controller.opsiTgl.value = 1;
                    controller.hariini.value = 'Tgl Hari Ini';
                    controller.descripsi.value = 'Tgl :';
                    controller.waktuSekarang.value = DateTime.now();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 2, bottom: 4),
                    decoration: BoxDecoration(
                        color: controller.opsiTgl.value == 1
                            ? Colors.red
                            : Colors.blue[200],
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text(
                      'Hari Ini',
                      style: TextStyle(
                          color: controller.opsiTgl.value == 1
                              ? Colors.white
                              : Colors.black),
                    )),
                  ),
                )),
          ),
          Expanded(
            child: Obx(() => InkWell(
                  onTap: () {
                    controller.opsiTgl.value = 2;
                    controller.hariini.value = 'Tgl Order';
                    controller.descripsi.value = 'Order Tgl :';
                    controller.orderTime(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                    decoration: BoxDecoration(
                        color: controller.opsiTgl.value == 2
                            ? Colors.red
                            : Colors.blue[200],
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text('Pilih tanggal',
                            style: TextStyle(
                                color: controller.opsiTgl.value == 2
                                    ? Colors.white
                                    : Colors.black))),
                  ),
                )),
          ),
          Expanded(
            child: Obx(() => InkWell(
                  onTap: () {
                    controller.opsiTgl.value = 3;
                    controller.hariini.value = 'Tgl Hari Ini';
                    controller.descripsi.value = 'Berulang Tgl';
                    controller.waktuSekarang.value = DateTime.now();
                    showDialog(
                        context: context, builder: (context) => dialogUlangi());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 2, right: 4, bottom: 4),
                    decoration: BoxDecoration(
                        color: controller.opsiTgl.value == 3
                            ? Colors.red
                            : Colors.blue[200],
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text(
                      'Ulangi',
                      style: TextStyle(
                          color: controller.opsiTgl.value == 3
                              ? Colors.white
                              : Colors.black),
                    )),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget dialogUlangi() {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 500,
        child: Column(
          children: [
            const Text(
              'Pilih Hari ',
              style: TextStyle(fontSize: 18),
            ),
            const Padding(
              padding: EdgeInsets.all(4),
              child: Divider(
                thickness: 2,
              ),
            ),
            Obx(() => ListTile(
                  leading: Checkbox(
                      value: controller.senin.value,
                      onChanged: (value) {
                        controller.senin.value = value!;
                      }),
                  title: const Text('Senin'),
                )),
            Obx(() => ListTile(
                  leading: Checkbox(
                      value: controller.selasa.value,
                      onChanged: (value) {
                        controller.selasa.value = value!;
                      }),
                  title: const Text('Selasa'),
                )),
            Obx(() => ListTile(
                  leading: Checkbox(
                      value: controller.rabu.value,
                      onChanged: (value) {
                        controller.rabu.value = value!;
                      }),
                  title: const Text('Rabu'),
                )),
            Obx(() => ListTile(
                  leading: Checkbox(
                      value: controller.kamis.value,
                      onChanged: (value) {
                        controller.kamis.value = value!;
                      }),
                  title: const Text('Kamis'),
                )),
            Obx(() => ListTile(
                  leading: Checkbox(
                      value: controller.jumat.value,
                      onChanged: (value) {
                        controller.jumat.value = value!;
                      }),
                  title: const Text('Jum\'at'),
                )),
            Obx(() => ListTile(
                  leading: Checkbox(
                      value: controller.sabtu.value,
                      onChanged: (value) {
                        controller.sabtu.value = value!;
                      }),
                  title: const Text('Sabtu'),
                )),
            Obx(() => ListTile(
                  leading: Checkbox(
                      value: controller.minggu.value,
                      onChanged: (value) {
                        controller.minggu.value = value!;
                      }),
                  title: const Text('Minggu'),
                )),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                color: Colors.blue,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Center(
                    child: Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

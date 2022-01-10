import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pekerjaan/app/data/model/model_pekerjaan.dart';

import '../controllers/pekerjaan_controller.dart';

class PekerjaanView extends GetView<PekerjaanController> {
  const PekerjaanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Semua Pekerjaan'),
      ),
      body: GestureDetector(
        child: Stack(
          children: [
            body(),
            menambahPekerjaan(),
          ],
        ),
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
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: pekerjaan.length,
              itemBuilder: (context, index) => ListTile(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => dialogEdit(pekerjaan[index].id));
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
                    : Text('(${pekerjaan[index].name!})',
                        style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough)),
                trailing: Text(pekerjaan[index].namePekerja!,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            );
          }
        });
  }

  Dialog dialogEdit(idtugas) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(18),
          height: 260,
          child: Column(
            children: [
              const Text(
                'Pilihan Mengedit',
                style: TextStyle(fontSize: 18),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              const Expanded(child: SizedBox()),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          controller.mengerjakan(idtugas);
                          Get.back();
                        },
                        child: const Center(
                          child: Text(
                            'Ganti Saya',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
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

  Widget menambahPekerjaan() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          requesTanggal(),
          Container(
            height: 75,
            alignment: Alignment.bottomCenter,
            color: Colors.blue[200],
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (val) {
                // ignore: avoid_print
                print(val);
              },
              controller: controller.input,
              decoration: InputDecoration(
                  suffix: GestureDetector(
                      onTap: () {
                        controller.menambahkanPekerjan();
                      },
                      child: const Icon(Icons.send)),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Tambah tugas'),
            ),
          ),
        ],
      );

  Widget requesTanggal() {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: Obx(() => InkWell(
                  onTap: () => controller.opsiTgl.value = 1,
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
                  onTap: () => controller.opsiTgl.value = 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 2, right: 2, bottom: 4),
                    decoration: BoxDecoration(
                        color: controller.opsiTgl.value == 2
                            ? Colors.red
                            : Colors.blue[200],
                        borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text('Order',
                            style: TextStyle(
                                color: controller.opsiTgl.value == 2
                                    ? Colors.white
                                    : Colors.black))),
                  ),
                )),
          ),
          Expanded(
            child: Obx(() => InkWell(
                  onTap: () => controller.opsiTgl.value = 3,
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
}

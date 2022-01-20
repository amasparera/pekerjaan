import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
      backgroundColor: const Color(0xff17182D),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(controller.argumen.name!),
        centerTitle: true,
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
        .doc(controller.argumen.idPekerjaan)
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
          ? const Icon(
              Icons.circle_outlined,
              color: Colors.white70,
            )
          : const Icon(Icons.run_circle_rounded, color: Colors.orange),
      title: pekerjaan[index].status == false
          ? Text(pekerjaan[index].name!,
              style: const TextStyle(color: Colors.white))
          : Text(
              pekerjaan[index].name!,
              style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.lineThrough,
                  decorationStyle: TextDecorationStyle.solid),
            ),
      subtitle: Text(
        DateFormat.MMMd().format(pekerjaan[index].hariIni!),
        style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
      trailing: Text(pekerjaan[index].namePekerja!,
          style: const TextStyle(
              color: Colors.orange, fontWeight: FontWeight.bold)),
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

  Widget menambahPekerjaan(context) => FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => controller.open.value == false
                  ? const SizedBox()
                  : requesTanggal(context),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18 / 2,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 32,
                    color: const Color(0xFF087949).withOpacity(0.08),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.open.value = !controller.open.value;
                      },
                      child: const Icon(Icons.more_vert_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18 * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sentiment_satisfied_alt_outlined,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                            const SizedBox(width: 18 / 4),
                            Expanded(
                              child: TextField(
                                controller: controller.input,
                                decoration: const InputDecoration(
                                  hintText: "Name tugas",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18 / 4),
                            GestureDetector(
                              onTap: () {
                                controller.menambahkanPekerjan();
                              },
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget requesTanggal(context) {
    return Container(
      height: 114,
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Text('Tanggal :'),
                const Spacer(),
                Obx(() => controller.opsiTgl.value != true
                    ? Text(DateFormat.yMMMd()
                        .format(controller.waktuDipilih.value))
                    : Text(DateFormat.MMMd()
                            .format(controller.range.value.start) +
                        ' sampai ' +
                        DateFormat.MMMd().format(controller.range.value.end))),
                TextButton(
                    onPressed: () {
                      if (controller.opsiTgl.value != true) {
                        controller.orderTime(context);
                      } else {
                        controller.rangeWaktu(context);
                      }
                    },
                    child: const Text('edit'))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Text('Status   :'),
                const Spacer(),
                Obx(() => Text(
                      controller.opsiTgl.value == false ? 'sekali' : 'ulangi',
                      style: const TextStyle(color: Colors.black),
                    )),
                const SizedBox(width: 6),
                Obx(() => Switch(
                    value: controller.opsiTgl.value,
                    onChanged: (val) {
                      controller.opsiTgl.value = val;
                      if (val == false) {
                        controller.range.value = DateTimeRange(
                            start: DateTime.now(), end: DateTime.now());
                      }
                    })),
              ],
            ),
          )
        ],
      ),
    );
  }
}
